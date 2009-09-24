$KCODE='u'

class IrrRealEstate
  require 'geokit'
  require 'vendor/plugins/geokit-rails/init.rb'
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  require 'json'
  require 'base64'
  include Geokit::Geocoders

  def self.parse wait = true, pause = true, estate_type = ''
    irr = IrrRealEstate.new
    irr.parse_irr wait, pause, estate_type
  end

  def parse_irr wait = true, pause = true, estate_type = ''
    @default_street = 'Не определена'
    @wait = wait
    @pause = pause
    @have_errors = 0
    @total_count = 0
    @errors = []
    @new_realties = 0

    beginning = Time.now
    
    unless estate_type.blank?
      parse_estate_type estate_type
    else
      parse_estate_type "rent"
      parse_estate_type "apartments-sale/secondary"
      parse_estate_type "garage"
      parse_estate_type "out-of-town/houses"
      parse_estate_type "out-of-town/lands"
      #parse_estate_type "commercial"
    end

    result = "Parsing results:"
    @errors.each do |error|
      result += "\r\n#{error}"
    end

    result += "\r\nTotal:#{@total_count}. New: #{@new_realties}. Errors:#{@have_errors}(#{100*@have_errors/@total_count}%). Execution time: #{Time.now - beginning}"
    result
  end

  def parse_estate_type estate_type
    @exist_adverts = 0
    begin
      for page in 1..30 do
        parse_page estate_type, page
        if @exist_adverts >= 40
          puts "Breaking parsing due existing adverts"
          break
        end
      end
    rescue Exception => exc
      @errors << "Critical error while parsing estate_type: #{estate_type}. Exception: #{exc}"
      @total_count += 1
    end
  end
  
  def parse_page estate_type, page
    url = "http:\/\/vladimir.irr.ru\/real-estate\/#{estate_type}\/page#{page}"
    puts "Parsing page #{page}. Estate type:#{estate_type}. Url: #{url}"
    doc = Nokogiri::HTML(open(url))
    (doc/"table#adListTable"/"*[@onclick*='document.location']").each do |ad|
      advert = ad["onclick"].scan(%r{document.location = '(.*)'})  
      begin
        @total_count = @total_count + 1
        parse_advert(advert)
        wait_for_user if @pause
      rescue Exception => exc
        puts exc
        if exc.message == "User break"
          raise "User break"
        elsif exc.message == "Continue"
          wait_for_user
        else
          @have_errors = @have_errors + 1
          @errors << "Advert:#{advert}. #{exc.message}"
          wait_for_user
        end
      end
    end
    ""
  end

  def wait_for_user
    raise "User break" if @wait && gets.strip == "s"
  end

  def parse_advert_by_id irr_id
    @default_street = 'Не определена'
    @wait = false
    @pause = false
    @have_errors = 0
    @total_count = 0
    @errors = []
    @exist_adverts = 0
    @new_realties = 0

    begin
      parse_advert "/advert/#{irr_id}"
    rescue Exception => exc
      puts exc
    end
  end

  def parse_advert advert_link
    puts advert_link

    doc = Nokogiri::HTML(open("http:\/\/vladimir.irr.ru#{advert_link}"), "http:\/\/vladimir.irr.ru#{advert_link}", 'u')

    irr_id = doc.at("input#ad_id")[:value]
    @realty = Realty.find_by_irr_id irr_id
    if @realty.blank?
      @realty = Realty.new :irr_id => irr_id
    else
      @exist_adverts += 1
    end

    @realty.street = nil

    puts "Parse price"
    price = doc.at("input#ar_price")
    parse_field "Price", price.nil? ? "0.2" : price[:value]

    puts "Parse custom fields"
    (doc/"table.customfields"/"tr").each do |field|
      parse_field field.at("th").inner_text, field.at("td").inner_text, doc
    end

    puts "Parse description"
    description = doc.at("div.additional-text p")
    parse_field "Description", description.inner_text unless description.blank?

    puts "Parse realty type"
    if @realty.realty_type.blank?
      realty_type = get_realty_type(doc)
      if realty_type == "continue"
        return ""
      else
        @realty.realty_type = realty_type
      end
    end

    puts "Realty type: #{@realty.realty_type.name}. Purpose:#{@realty.realty_type.realty_purpose.name}"

    phone = doc.at("li.ico-phone")
    phone = phone.inner_text unless phone.blank?
    
    m_phone = doc.at("li.ico-mphone")
    m_phone = m_phone.inner_text unless m_phone.blank?

    puts "Parsing contact and email"
    contact_p = doc.at("div.contacts-info p")
    if contact_p.blank?
      if !phone.blank?
        contact = phone
      elsif !m_phone.blank?
        contact = m_phone
      else
        raise "Can't create contact because phones are empty"
      end
    else
      contact = contact_p.inner_text
    end

    email_script = doc.at("ul.cont-ico script")
    if email_script.blank?
      email = "#{contact}@reestry.ru"
    else
      email = Base64.decode64(/base64_decode\('([^']+)'\)/.match(email_script.inner_text)[1])
    end

    create_user contact, email
    puts @realty.user.inspect
    parse_field "Contact", contact unless contact_p.blank?

    parse_field "Phone", phone unless phone.blank?

    m_phone = doc.at("li.ico-mphone")
    parse_field "Mobile Phone", m_phone.inner_text.gsub(/\D/, "") unless m_phone.blank?

    icq = doc.at("li.ico-icq")
    parse_field "ICQ", icq.inner_text.gsub(/\D/, "") unless icq.blank?
    
    date = doc.at("li#ad_date_create")
    date = Time.at date.inner_text.to_i
    
    puts "Created Date: #{date}"
    if @realty.id.blank?
      @realty.created_at = date
      @realty.expire_at = date.advance(:months => 1)
      @new_realties += 1
    end

    parse_place_and_district #if @realty.district_id.blank?

    if @realty.id.blank? && @realty.service_type_id.blank?
      puts 'Use default service type'
      wait_for_user
      @realty.service_type = ServiceType.find_by_name("Продажа")
    end

    puts @realty.inspect
    puts @realty.user.inspect
    @realty.save!
    @realty
  end

  def parse_field field_name, field_value, doc = ""
    field_name = field_name.strip.gsub(":","").gsub("?","")
    field_value = field_value.strip

    puts "Field: #{field_name}. Value: #{field_value}"

    if field_name == "Price"
      @realty.price = field_value.blank? ? 0 : field_value.to_d
      @realty.currency = Currency.find_by_short_name "РУБ"
    elsif field_name == "Тип объекта"
      @realty.realty_type = get_realty_type(doc, field_value)
    elsif field_name == "Тип предложения"
      @realty.service_type = get_service_type field_value
    elsif field_name == "Регион"
      @realty.irr_region = field_value
    elsif field_name == "Общая площадь" || field_name == "Площадь участка в сотках"
      @realty.total_area = field_value
      @realty.area_unit_id = 1
    elsif field_name == "Улица"
      @realty.street = field_value
    elsif field_name == "Contact"
      add_contact(ContactType.find_by_name("Контактное лицо"), field_value)
    elsif field_name == "Phone"
      add_contact(ContactType.find_by_name("Телефон"), field_value)
    elsif field_name == "Mobile Phone"
      add_contact(ContactType.find_by_name("Моб. телефон"), field_value)
    elsif field_name == "ICQ"
      add_contact(ContactType.find_by_name("ICQ"), field_value)
    elsif field_name == "Дом"
      @realty.number = field_value
    elsif field_name == "Description"
      @realty.description = clear_description field_value
      continue_if_agency
      parse_street_from_text @realty.description if @realty.street.blank?
    else
      get_field_value field_name, field_value
    end
  end

  def create_user name, email
    puts "Creating user with name #{name} and email #{email}"
    user = User.find_by_email(email)
    user = User.find_by_login(name) if user.blank?
    user = User.new :login => name, :email => email,
      :password => 'password', :password_confirmation => 'password' if user.blank?
    @realty.user = user
  end

  def add_contact contact_type, value
    contact = Contact.find_by_value_and_contact_type_id(value, contact_type.id)
    contact = Contact.new(:user => @realty.user, :contact_type => contact_type, :value => value) if contact.blank?
    @realty.contacts << contact unless @realty.contacts.find_by_value_and_contact_type_id(contact.value, contact.contact_type_id)
    contact
  end

  def get_field_value field_name, field_value
    value = nil
    IrrParser.find_all_by_name(field_name).each do |irr_parser|
      realty_field = irr_parser.realty_field
      if irr_parser.parser.blank?
        value = field_value
        value = 1 if realty_field.realty_field_type.name == 'bool'
      else
        value = parse_field_value irr_parser.parser, field_value
      end

      if realty_field.realty_field_type.name == 'list'
        lfv = ListFieldValue.find_by_name_and_realty_field_id(value, realty_field.id)
        raise "Can't find list field value: #{value}. Field: #{realty_field.id}" if lfv.blank?
        puts "Found list field value: #{lfv.id}. Field: #{realty_field.id}"
        value = lfv.id
      end

      rfv = @realty.realty_field_values.find_by_realty_field_id(realty_field.id)
      if rfv.blank?
        rfv = RealtyFieldValue.new(:realty_field => realty_field, :realty => @realty)
        rfv.value = value
        @realty.realty_field_values << rfv
      end

      rfv.value = value
      rfv.save! unless @realty.id.blank?
    end
      
    raise "Can't find value of field:#{field_name}, value:#{field_value}" if value.blank?
    puts "Found value:#{value.to_s}"
  end

  def parse_field_value parser_hash, field_value
    parser_hash.split(',').each do |reg_exp_with_value|
      reg_exp = reg_exp_with_value.split(':')[0].strip
      value = reg_exp_with_value.split(':')[1]
      
      field_value =~ Regexp.new(reg_exp, 'i')
      return value unless $&.nil?
    end

    raise "Can't parse #{field_value} by parser:#{parser_hash.inspect}"
  end

  def get_service_type text
    text = text
    text =~ /(сдам)/i
    text =~ /(сниму)/i if $1.nil?
    return ServiceType.find_by_name("Аренда") unless $1.nil?
    text =~ /(продам)/i
    text =~ /(куплю)/i if $1.nil?
    text =~ /(предложение)/i if $1.nil?
    return ServiceType.find_by_name("Продажа") unless $1.nil?

    raise "Can't find service type:#{text}" if $1.nil?
  end

  def get_realty_type doc, type = ""
    live_purpose = RealtyPurpose.find_by_name "Жилое"
    return live_purpose.realty_types.find_by_name("Комната") unless doc.at("a.arrdown[@href='/real-estate/rent/rooms-offers/']").nil?
    return live_purpose.realty_types.find_by_name("Комната") if !doc.at("a.arrdown[@href='/real-estate/apartments-sale/secondary/']").nil? && !@realty.description.blank? && !@realty.description.scan(/[К|к]омнату/i).blank?
    return live_purpose.realty_types.find_by_name("Квартира") unless doc.at("a.arrdown[@href='/real-estate/rent/appartments-offers/']").nil?
    return live_purpose.realty_types.find_by_name("Квартира") unless doc.at("a.arrdown[@href='/real-estate/apartments-sale/secondary/']").nil?
    return live_purpose.realty_types.find_by_name("Дом") unless doc.at("a.arrdown[@href='/real-estate/out-of-town/houses/']").nil?
    return live_purpose.realty_types.find_by_name("Участок") unless doc.at("a.arrdown[@href='/real-estate/out-of-town/lands/']").nil?
    return live_purpose.realty_types.find_by_name("Комната") if !doc.at("a.arrdown[@href='/real-estate/rent/']").nil? && type == "комната"
    return live_purpose.realty_types.find_by_name("Квартира") if !doc.at("a.arrdown[@href='/real-estate/rent/']").nil?
    return live_purpose.realty_types.find_by_name("Участок") if !doc.at("a.arrdown[@href='/real-estate/out-of-town/lands/']").nil?

    other_purpose = RealtyPurpose.find_by_name "Другое"
    return other_purpose.realty_types.find_by_name("Гараж") unless doc.at("a.arrdown[@href='/real-estate/garage/']").nil?

    return "continue" unless doc.at("a.arrdown[@href='/real-estate/rent/demand/']").nil?
    return "continue" unless doc.at("a.arrdown[@href='/real-estate/secondary/purchase/']").nil?
    return "continue" unless doc.at("a.arrdown[@href='/real-estate/secondary/appartments-exchange/']").nil?
    return "continue" unless doc.at("a.arrdown[@href='/real-estate/secondary/other/']").nil?
    return "continue" unless doc.at("a.arrdown[@href='/real-estate/secondary/room-exchange/']").nil?

    raise "Can't find realty type"
  end

  def parse_place_and_district
    s = @realty.irr_region.scan(/([^»]+)»?(.*)/).first
    puts s.second
    space = "" << 194 << 160
    location_name = s.first.gsub(space, "").gsub("область", "обл.")
    district = s.second.gsub(space, "") unless s.second.blank?
    puts "Irr_Region:#{@realty.irr_region}. Location:#{location_name}. District:#{district}"

    location = Location.find_by_name(location_name)
    raise "Can't find location #{location_name}." if location.blank?

    @realty.district = District.find_by_name district.gsub("?", "").strip unless district.blank?

    if @realty.street.blank?
      #if street is blank use default street
      use_default_street

      if @realty.district.blank?
        puts "Use first district because district '#{district} not found."
        @realty.district = District.first
      end
    else
      #if district blank try to find district from street
      if @realty.district.blank?
        district_street = DistrictStreet.find(:first, :conditions => ["street like ?", "%#{@realty.street}%"])

        unless district_street.blank?
          #@realty.street = parse_street_from_text(district_street.street)
          @realty.district_id = district_street.district_id
        else
          puts "Can't find district by street #{@realty.street}"
          @realty.district = District.first
        end
      end

      #now we should have district and street
      geodata = retrieve_geodata location.name
      @realty.is_exact = !geodata.nil?
      use_default_street if geodata.nil?
    end
  end

  def retrieve_geodata location_name
    geodata = get_geodata location_name
    puts "Geodata: #{geodata}"

    if check_geodata?(location_name, geodata)
      #parse_street_from_text(geodata.street_address) if !geodata.street_address.blank?
      @realty.lat = geodata.lat
      @realty.lng = geodata.lng
    else
      puts "Did not find geodata"
      geodata = nil
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

  def check_geodata? location, geodata
    @center = get_geodata_by_address "#{location},Россия" if @center.blank?
    @realty.distance = Realty.distance_between(@center, geodata, :units => :kms)
    puts "Distance from #{location} is #{@realty.distance}"
    geodata.success? && @realty.distance < 220
  end

  def get_geodata_by_address address
    puts "Get geodata by '#{address}'"
    geodata = YandexGeocoder.geocode(address)
    geodata = GoogleGeocoder.geocode(address) unless geodata.success
    geodata
  end

  def clear_description desc
     desc.gsub(/\WДата выхода объявления.+/, '')
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
    text =~ /(Снять-сдать)\W/i if $1.nil?
    text =~ /(Строительство)\W/i if $1.nil?
    text =~ /(ипоте.+кредит.+)\W/i if $1.nil?
    text =~ /(Ипотека)\W/i if $1.nil?
    text =~ /(риэлтор.+услуг.+)\W/i if $1.nil?
    text =~ /(сниму)\W/i if $1.nil?
    text =~ /(снимет)\W/i if $1.nil?

    raise "Continue" unless $1.nil?
  end

  def parse_street_from_text text
    #$KCODE = "UTF8"
    puts "Parse string from text: #{text}"
    r_name = '\w+[^,\(\)\w]*\w*'
    text =~ /ул\W+((?!план\.)#{r_name})/i
    text =~ /[^\w]дер\.\W*(#{r_name})/i if $1.nil?
    text =~ /[^\w]д\.\W*(#{r_name})/i if $1.nil?
    text =~ /[^\w]с\.\W*(#{r_name})/i if $1.nil?
    text =~ /[^\w]ст\.\W*(\w+[^,\w]*\w*)/i if $1.nil?
    text =~ /[^\w]г\.\W*(#{r_name})/i if $1.nil?
    text =~ /в селе\W+(#{r_name})/i if $1.nil?
    text =~ /в деревне\W+(#{r_name})/i if $1.nil?
    text =~ /[П|п]оселок\W+(#{r_name})/i if $1.nil?
    text =~ /[Г|г]ород\W+(#{r_name})/i if $1.nil?
    text =~ /на\W+(#{r_name})\W+пр/i if $1.nil?
    text =~ /пр-кт\W+(#{r_name})/i if $1.nil?
    text =~ /просп\W+(#{r_name})/i if $1.nil?
    text =~ /проспект\W+(#{r_name})/i if $1.nil?
    text =~ /(#{r_name})\s+проспект/i if $1.nil?
    text =~ /пр\W+(#{r_name})/i if $1.nil?
    text =~ /на\W+((?!.+\sсрок)#{r_name})/i if $1.nil?
    text =~ /в\W+(#{r_name})\W+в\/г/i if $1.nil?
    

    street = $1
    if !street.nil? && !street.scan(/([К|к]омн)|([М|м]алосем)/i).blank?
      text =~ /(#{r_name})\W+ул\W+/i
      text =~ /(#{r_name})\W+пр\W+/i if $1.nil?
      text =~ /(#{r_name})\W+м\/р-н\W+/i if $1.nil?
      street = $1
    end

    unless street.nil?
      puts "Found street from text: #{street}"
      @realty.street = street.strip
    end
  end

end
