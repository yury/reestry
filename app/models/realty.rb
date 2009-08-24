class Realty < ActiveRecord::Base

  validates_presence_of :street, :price, :currency_id, :realty_type_id, :service_type_id, :district_id
  validates_numericality_of :price
  
  belongs_to :realty_type
  belongs_to :currency
  belongs_to :area_unit
  belongs_to :service_type
  belongs_to :user
  belongs_to :district
  has_many :realty_field_values, :dependent => :destroy
  has_many :realty_photos, :dependent => :destroy
  has_and_belongs_to_many :contacts

  acts_as_mappable :default_units => :kms,
                   :default_formula => :flat

  attr_accessor :irr_region
  
  def get_location_id
    self.district.blank? ? nil : self.district.location_id
  end
  
  def self.search_query params
    pars = []
    query = "SELECT realties.* FROM realties"

    unless params[:f].blank?
      params[:f].each_with_index do |p, i|
        unless p[1].blank?
          join_table = "rfv" + i.to_s
          query += " INNER JOIN realty_field_values as #{join_table} ON realties.id = #{join_table}.realty_id AND #{join_table}.realty_field_id = ?"
          pars << p[0]
          query += " AND #{join_table}.value = ?"
          pars << p[1]
        end
      end
    end
    
    unless params[:f_from].blank?
      params[:f_from].each do |p_from|
        join_table = "rfvf#{p_from[0]}"
        p_to = params[:f_to][p_from[0]]

        if !p_from[1].blank? || !p_to[1].blank?
          query += " INNER JOIN realty_field_values as #{join_table} ON realties.id = #{join_table}.realty_id AND #{join_table}.realty_field_id = ?"
          pars << p_from[0]

          unless p_from[1].blank?
            query += " AND #{join_table}.value >= ?"
            pars << p_from[1]
          end

          unless p_to[1].blank?
            query += " AND #{join_table}.value <= '?'"
            pars << p_to[1]
          end
        end
      end
    end
    
    query += " WHERE expire_at >= now()"
    query += equal pars, params[:service], "service_type_id"
    query += equal pars, params[:district], "district_id"
    query += equal pars, params[:type], "realty_type_id"
    query += like pars, params[:place], "place"
    query += like pars, params[:street], "street"
    query += like pars, params[:number], "number"
    query += op pars, params[:price_from], ">=", "price"
    query += op pars, params[:price_to], "<=", "price"
    query += op pars, params[:area_from], ">=", "total_area"
    query += op pars, params[:area_to], "<=", "total_area"
    query += range("district_id", District.find_all_by_location_id(params[:location]).map(&:id)) unless params[:location].blank?

    query += " GROUP BY user_id HAVING count(*) = 1" if params[:non_agency]
    
    if params[:sort]
      sort_dir = params[:sdir] == "asc" ? "asc" : "desc"
      sort_pars = {"service" => "service_type_id", 
                   "type" => "realty_type_id", 
                   "location" => "district_id",
                   "address" => "concat(ifnull(place,''), ifnull(street,''), ifnull(number,''))",
                   "price" => "if(price>1, price, predict_price)",
                   "area" => "total_area",
                   "date" => "created_at"
                   }
      sort = sort_pars[params[:sort]] || "price"
      query += " ORDER BY #{sort} #{sort_dir}, created_at desc"
    else
      query += " ORDER BY created_at desc"
    end
        
    result = []
    result << query
    result.concat(pars)
    puts result.inspect
    result
  end
  
  def self.select params
    paginate_by_sql search_query(params), :page => params[:page], :per_page => 15
  end

  def self.select_by_user_id user_id
    paginate_by_user_id user_id, :page => 1, :per_page => 1
  end

  def self.stats
    result = {}
    result[:count] = Realty.count
    result[:exact_realties] = Realty.count(:conditions => "is_exact = 1") * 100.00 / Realty.count
    result[:non_agency] = Realty.count_by_sql("select sum(c) from (select count(*) c from realties group by user_id having count(*) = 1) a") * 100.00 / Realty.count
    result
  end

  def self.price_limits service_type_id, realty_type_id
    limit = Rails.cache.fetch("price_limits_#{service_type_id}_#{realty_type_id}") {
      Realty.find_by_sql(["select min(price) as min, max(price) as max from realties where service_type_id = ? and realty_type_id = ? and expire_at >= now()",
          service_type_id, realty_type_id]).map {|r| [r.min.to_i, r.max.to_i]}.first
    }

    {:min => limit[0], :max => limit[1], :step => 10**((limit[1]+100).to_s.length-3)}
  end

  def price_or_predict
    price_blank? ? predict_price : price
  end

  def price_blank?
    price < 1
  end

  def user_can_edit? current_user
    !current_user.blank? && (user_id == current_user.id || current_user.is_admin)
  end

  def new?
    (Time.now - created_at)/3600/24 <= 7
  end

  def update_geodata
    loc = "Россия,#{district.location.name},#{district.name if !district.location.is_place},#{place if !district.location.is_place},#{street},#{number}"
    geodata = Geokit::Geocoders::YandexGeocoder.geocode(loc)
    geodata = Geokit::Geocoders::GoogleGeocoder.geocode(loc)  unless geodata.success
    if geodata.success
      self.lat = geodata.lat
      self.lng = geodata.lng
      self.is_exact = true
    end
    geodata
  end

  def full_description
    result = ""
    if realty_type == RealtyType.find_by_name("Квартира")
      result += "#{field_value("Количество комнат")}-комн. "
    elsif realty_type == RealtyType.find_by_name("Комната")
    elsif realty_type == RealtyType.find_by_name("Дом")
    elsif realty_type == RealtyType.find_by_name("Участок")
    elsif realty_type == RealtyType.find_by_name("Гараж")
      result += description
    end

    result
  end
  
  protected
  def field_value name
    value = realty_field_values.find_by_realty_field_id(RealtyField.find_by_name(name))
    value.string_value unless value.blank?
  end

  def validate
    errors.add(:price, "должна быть не менее 0.01") if price.nil? || price < 0.01
  end
  
  def self.equal pars, param, field_name
    return "" if param.blank?
    pars << param
    " AND #{field_name} = ?"

  end
  
  def self.like pars, param,  field_name
    return "" if param.blank?
    pars << "%#{param}%"
    " AND #{field_name} LIKE ?"
    
    
  end
  
  def self.op pars, param, oper, field_name
    return "" if param.blank?
    pars << param
    " AND #{field_name} #{oper} ?"
  end
  
  def self.range field_name, in_coll
    " AND #{field_name} IN (#{in_coll.join(",")})"
  end
end



