class Pricer
  
  cattr_reader(:data_cache)
  
  @@data_cache = {}

  def self.predict_price realty
    start_time = Time.now

    data = get_data_for_pricing realty
    vector = get_input_from_realty realty
    price = Pricing.knn_estimate(data, vector)

    puts "Execution time: #{Time.now - start_time}"
    price
  end

  def self.analyze_algorithms
    puts 'Analize weighted_knn_estimate algorithm (k=5)'
    analyze_algorithm() { |data, vector| Pricing.weighted_knn_estimate(data,vector) {|dist| Pricing::Weights.subtract_weight(dist)}}
    puts 'Analize knn_estimate algorithm (k=3)'
    analyze_algorithm() { |data, vector| Pricing.knn_estimate(data, vector) }
  end

  def self.analyze_algorithm &algo
    overall_result = 0.0
    tries = 0
    Realty.find_by_sql("select * from realties group by service_type_id, realty_type_id").each do |realty|
      puts "Test algo for service_type=#{realty.service_type.name} and realty_type=#{realty.realty_type.name}"
      result = Pricing.cross_validate(get_data_for_pricing(realty), &algo)
      puts "Result: #{result*100}%"
      tries = tries + 1
      overall_result += result
    end

    puts "Overall result: #{overall_result*100/tries}%"
  end

  def self.list_cache realty
    if get_data_from_cache(realty).blank?
      puts "No data cache for this realty"
    elsif
      get_data_from_cache(realty).sort_by {|r| r.result}.each do |row|
        puts "#{row.result.to_s}"
      end
    end
  end

  def self.get_conditions realty
    ["service_type_id = ? and realty_type_id = ? and price > 0.2 and expire_at >= ?",
        realty.service_type_id, realty.realty_type_id, Time.today.advance(:months => -2)]
  end

  def self.get_data_for_pricing realty
    data = []
    conditions = get_conditions(realty)

    unless get_data_from_cache(realty).blank?
      puts "Use data (#{get_data_from_cache(realty).length} rows) from cache (#{conditions.hash})"
      return get_data_from_cache(realty)
    end
    

    Realty.find(:all, :conditions => conditions).each do |r|
      data << Pricing.make_data(r.price, get_input_from_realty(r))
    end
    puts "Generate #{data.length} rows for prediction"

    puts "Save data to cache (#{conditions.hash})"
    set_data_to_cache(realty, data)
  end

  def self.get_input_from_realty realty
    input = []
    input << (realty.total_area.blank? ? 0 : realty.total_area)
    input << 1 / (realty.distance.blank? ? 1 : realty.distance)

    RealtyField.find_all_by_predict(1).each do |predict_field|
      field_value = realty.realty_field_values.find_by_realty_field_id(predict_field.id)
      field_type = predict_field.realty_field_type
      value = 0

      if(!field_value.blank?)
        field_value = field_value.value
        raise "Can't use string value for prediction" if field_type.string?
        value = predict_field.list_field_values.find(field_value).weight if field_type.list?
        value = field_value ? 1 : 0 if field_type.bool?
        value = field_value if field_type.decimal? || field_type.int?
      end

      input << value.to_i
    end
    input
  end

  private

  def self.get_data_id realty
    "service_type_id = #{realty.service_type.name} and realty_type_id = #{realty.realty_type.name}".hash
  end

  def self.get_data_from_cache realty
    @@data_cache[get_data_id(realty)]
  end

  def self.set_data_to_cache realty, data
    @@data_cache[get_data_id(realty)] = data
  end
end
