class IrrRealEstate
  require 'rubygems'
  require 'hpricot'
  require 'open-uri'
  require 'json'

  def self.parse
    irr = IrrRealEstate.new
    irr.parse_rent
  end

  def parse_rent
    @user = User.find_by_email "admin@doma33.ru"
    @user = User.create :login => "admin", :email => "admin@doma33.ru",
      :password => "admin", :password_confirmation => "admin" if @user.blank?
    @user.save!
    
    parse_estate_type "rent"
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
      parse_advert(advert)
    end
    ""
  end

  def parse_advert advert_link
    puts advert_link

    doc = Hpricot(open("http:\/\/vladimir.irr.ru#{advert_link}"))

    irr_id = doc.at("input#ad_id")[:value]
    @realty = Realty.find_by_irr_id irr_id
    @realty = Realty.new :irr_id => irr_id,
      :realty_type => get_realty_type(doc), :user_id => @user.id if @realty.blank?

    price = doc.at("input#ar_price")
    parse_field "Price", price[:value] unless price.nil?

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
      parse_place_and_district field_value
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
    puts "Found value:#{value}"
  end

  def parse_field_value parser_hash, field_value
    parser_hash.each do |reg_exp, value|
      field_value =~ Regexp.new(reg_exp)
      return value unless $&.nil?
    end
  end

  def get_realty_type doc
    live_purpose = RealtyPurpose.find_by_name "Жилое"
    return live_purpose.realty_types.find_by_name("Комната") unless doc.at("a.arrdown[@href='/real-estate/rent/rooms-offers/']").nil?
    return live_purpose.realty_types.find_by_name("Квартира") unless doc.at("a.arrdown[@href='/real-estate/rent/appartments-offers/']").nil?
  end

  def parse_place_and_district field_value
    field_value =~ /\?+/
    @realty.district_id = 1

  end
end
