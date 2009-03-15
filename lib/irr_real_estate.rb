class IrrRealEstate
  require 'rubygems'
  require 'hpricot'
  require 'open-uri'

  def self.parse
    parse_rent
  end

  def self.parse_rent
    parse_estate_type "rent"
  end

  def self.parse_estate_type estate_type
    1.times do |page|
      page = page + 1
      parse_page estate_type, page
    end
  end
  
  def self.parse_page estate_type, page
    puts "Parsing page #{page}"
    doc = Hpricot(open("http:\/\/vladimir.irr.ru\/real-estate\/#{estate_type}\/page#{page}"))
    (doc/"table#adListTable"/"*[@onclick*='document.location']").each do |ad|
      advert = ad["onclick"].scan(%r{document.location = '(.*)'})
      #puts advert
      parse_advert(advert)
    end
    ""
  end

  def self.parse_advert advert_link
    doc = Hpricot(open("http:\/\/vladimir.irr.ru#{advert_link}"))

    price = doc.at("input#ar_price")
    parse_field "Price", price[:value] unless price.nil?

    (doc/"table.customfields"/"tr").each do |field|
      parse_field field.at("th").inner_text, field.at("td").inner_text
    end

    description = doc.at("div.additional-text p")
    parse_field "Description", description.inner_text unless description.blank?
    puts description.inner_text.trim unless description.blank?

    contact = doc.at("div.contact-info p")
    parse_field "Contact", contact.inner_text unless contact.blank?

    phone = doc.at("li.ico-phone")
    parse_field "Phone", phone.inner_text unless phone.blank?

    m_phone = doc.at("li.ico-mphone")
    parse_field "Mobile Phone", m_phone.inner_text unless m_phone.blank?

    parse_field "Irr ID", doc.at("input#ad_id")[:value]

    date = doc.at("li#ad_date_create")
    #puts Time.at date.inner_text.to_i unless date.nil?
  end

  def self.parse_field field_name, field_value
    field_name = field_name.trim
    field_value = field_value.trim

    #puts "Field: #{field_name}. Value: #{field_value}"
  end

end
