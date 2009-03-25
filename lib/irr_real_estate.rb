$KCODE = 'UTF8'

class IrrRealEstate
  require 'rubygems'
  require 'hpricot'
  require 'open-uri'
  require 'json'
  include Geokit::Geocoders

  def self.parse wait = true
    irr = IrrRealEstate.new
    irr.parse_irr wait
  end

  def parse_irr wait = true
    @default_street = 'Октябрьская'
    @wait = wait
    @have_errors = 0
    @total_count = 0

    @user = User.find_by_email "admin@doma33.ru"
    @user = User.create :login => "admin", :email => "admin@doma33.ru",
      :password => "admin", :password_confirmation => "admin" if @user.blank?
    @user.save!

    parse_estate_type "rent"

    "Total:#{@total_count}. Errors:#{@have_errors}(#{100*@have_errors/@total_count}%)"
  end

  def parse_estate_type estate_type
    for page in 1..30 do
      parse_page estate_type, page
    end
  end
  
  def parse_page estate_type, page
    puts "Parsing page #{page}"
    doc = Hpricot(open("http:\/\/vladimir.irr.ru\/real-estate\/#{estate_type}\/page#{page}"))
    (doc/"table#adListTable"/"*[@onclick*='document.location']").each do |ad|
      advert = ad["onclick"].scan(%r{document.location = '(.*)'})  
      begin
        @total_count = @total_count + 1
        parse_advert(advert)
      rescue Exception => exc
        puts exc
        if exc.message == "User break"
          raise "User break"
        elsif exc.message == "Continue"
          wait_for_user
        else
          @have_errors = @have_errors + 1
          wait_for_user
        end
      end
    end
    ""
  end

  def wait_for_user
    raise "User break" if @wait && gets.trim == "s"
  end

  def parse_advert advert_link
    puts advert_link

    doc = Hpricot(open("http:\/\/vladimir.irr.ru#{advert_link}"))

    irr_id = doc.at("input#ad_id")[:value]
    @realty = Realty.find_by_irr_id irr_id

    realty_type = get_realty_type(doc)
    return "" if realty_type == "continue"
    
    @realty = Realty.new :irr_id => irr_id,
      :realty_type => realty_type, :user_id => @user.id if @realty.blank?

    @realty.street = nil

    puts "Realty type: #{@realty.realty_type.name.to_win1251}. Purpose:#{@realty.realty_type.realty_purpose.name.to_win1251}"

    price = doc.at("input#ar_price")
    parse_field "Price", price.nil? ? "0.2" : price[:value]

    (doc/"table.customfields"/"tr").each do |field|
      parse_field field.at("th").inner_text, field.at("td").inner_text
    end

    description = doc.at("div.additional-text p")
    parse_field "Description", description.inner_text unless description.blank?
    
    contact = doc.at("div.contact-info p")
    parse_field "Contact", contact.inner_text unless contact.blank?

    phone = doc.at("li.ico-phone")
    parse_field "Phone", phone.inner_text unless phone.blank?

    m_phone = doc.at("li.ico-mphone")
    parse_field "Mobile Phone", m_phone.inner_text unless m_phone.blank?

    date = doc.at("li#ad_date_create")
    date = Time.at date.inner_text.to_i
    puts "Created Date: #{date}"
    @realty.created_at = date

    
    parse_place_and_district #if @realty.district_id.blank?

    puts @realty.inspect
    @realty.save!
  end

  def parse_field field_name, field_value
    field_name = field_name.to_win1251.trim.gsub(":","").gsub("?","")
    field_value = field_value.to_win1251.trim

    puts "Field: #{field_name}. Value: #{field_value}"

    if field_name == "Price"
      @realty.price = field_value.blank? ? 0 : field_value.to_d
      @realty.currency = Currency.find_by_short_name "РУБ"
    elsif field_name == "Тип предложения".to_win1251
      @realty.service_type = ServiceType.find_by_name "Аренда"
    elsif field_name == "Регион".to_win1251
      @realty.irr_region = field_value
    elsif field_name == "Общая площадь".to_win1251
      @realty.total_area = field_value
      @realty.area_unit_id = 1
    elsif field_name == "Улица".to_win1251
      @realty.street = field_value.to_utf8
    elsif field_name == "Phone"
    elsif field_name == "Mobile Phone"
    elsif field_name == "Дом".to_win1251
      @realty.number = field_value.to_utf8
    elsif field_name == "Description"
      @realty.description = field_value.to_utf8
      continue_if_agency
      parse_street_from_text @realty.description if @realty.street.blank?
    else
      get_field_value field_name, field_value
    end
  end

  def get_field_value field_name, field_value
    value = nil
    RealtyField.find_all_by_irr_name(field_name.to_utf8).each do |realty_field|
      if realty_field.irr_parser.blank?
        value = field_value
        value = 1 if realty_field.realty_field_type.name == 'bool'
      else
        parser = JSON.parse(realty_field.irr_parser)
        value = parse_field_value parser, field_value if parser.class == {}.class

      end
    end
      
    raise "Can't find value of field:#{field_name}, value:#{field_value}" if value.blank?
    puts "Found value:#{value.to_s}"
  end

  def parse_field_value parser_hash, field_value
    parser_hash.each do |reg_exp, value|
      field_value.to_utf8 =~ Regexp.new(reg_exp)
      return value unless $&.nil?
    end

    return ""
  end

  def get_realty_type doc
    live_purpose = RealtyPurpose.find_by_name "Жилое"
    return live_purpose.realty_types.find_by_name("Комната") unless doc.at("a.arrdown[@href='/real-estate/rent/rooms-offers/']").nil?
    return live_purpose.realty_types.find_by_name("Квартира") unless doc.at("a.arrdown[@href='/real-estate/rent/appartments-offers/']").nil?
    return "continue" unless doc.at("a.arrdown[@href='/real-estate/rent/demand/']").nil?

    raise "Can't find realty type"
  end

  def parse_place_and_district
    @realty.irr_region =~ /\?+/
    location = $`
    district = $'
    puts "Location:#{location}. District:#{district}"

    location = Location.find_by_name location.to_utf8.trim
    raise "Can't find location #{location}" if location.blank?

    use_default_street if @realty.street.blank?
    
    district = District.find_by_name district.gsub("?", "").to_utf8.trim

    if district.blank?
      district_street = DistrictStreet.find(:first, :conditions => ["street like ?", "%#{@realty.street}%"])
      puts "Street: #{@realty.street}"
      @realty.street = parse_street_from_text(district_street.street) unless district_street.blank?
      puts "Street: #{@realty.street}"
    end

    geodata = retrieve_geodata location.name
    use_default_street unless geodata.success?
    geodata = retrieve_geodata location.name

    if district.blank?
      district_street = DistrictStreet.find(:first,
      :conditions => ["street like ?", "%#{@realty.street}%"]) if district_street.blank? && geodata.success?

      raise "Can't find district by street #{@realty.street}" if district_street.blank?

      @realty.district_id = district_street.district_id
    else
      @realty.district = district
    end
  end

  def retrieve_geodata location_name
    geodata = get_geodata location_name
    puts "Geodata: #{geodata}"

    if geodata.success?
      parse_street_from_text(geodata.street_address) if !geodata.street_address.blank?
      @realty.lat = geodata.lat
      @realty.lng = geodata.lng
    else
      puts "Did not find geodata"
    end

    geodata
  end

  def use_default_street
      puts "Use default street because street is blank"
      @realty.street = @default_street
      @realty.is_exact = false
      wait_for_user
  end
  
  def get_geodata location
    address = "#{@realty.number},#{@realty.street},#{location},Россия"
    loc = get_geodata_by_address address
    return loc if loc.success?

    @realty.street =~ /\w+\W+(\w+)/i
    loc = get_geodata_by_address $1 unless $1.nil?
    return loc
  end

  def get_geodata_by_address address
    puts "Get geodata by '#{address.to_win1251}'"
    return GoogleGeocoder.geocode(address)
  end

  def continue_if_agency
    text = @realty.description
    text =~ /(АН)\W/i
    text =~ /\W(недвижимости)\W/i if $1.nil?
    text =~ /(ООО)\W/i if $1.nil?
    text =~ /(Аренда)\W/i if $1.nil?
    text =~ /(Сдача квартир)\W/i if $1.nil?
    text =~ /(сдать или снять)\W/i if $1.nil?
    text =~ /\W(в любом районе)\W/i if $1.nil?
    text =~ /\W(в любых районах)\W/i if $1.nil?
    text =~ /(сдать-снять)\W/i if $1.nil?

    raise "Continue" unless $1.nil?
  end

  def parse_street_from_text text
    puts "Parse string from text: #{text}"
    r_name = '\w+[^,\w]*\w*'
    text =~ /ул\W+((?!план\.)#{r_name})/i
    text =~ /на\W+(#{r_name})\W+пр/i if $1.nil?
    text =~ /пр-кт\W+(#{r_name})/i if $1.nil?
    text =~ /просп\W+(#{r_name})/i if $1.nil?
    text =~ /проспект\W+(#{r_name})/i if $1.nil?
    text =~ /пр\W+(#{r_name})/i if $1.nil?
    text =~ /на\W+(#{r_name})/i if $1.nil?
    text =~ /в\W+(#{r_name})\W+в\/г/i if $1.nil?

    unless $1.nil?
      puts "Found street from text: #{$1.to_win1251}"
      @realty.street = $1.trim
    end
  end

end
