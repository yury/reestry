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

  def self.get_data_for_pricing realty
    data = []
    conditions = ["service_type_id = ? and realty_type_id = ? and price > 0.2 and expire_at >= ?",
        realty.service_type_id, realty.realty_type_id, Time.today.advance(:months => -2)]

    unless @@data_cache[conditions.hash].blank?
      puts 'Use data from cache'
      return @@data_cache[conditions.hash]
    end
    

    Realty.find(:all, :conditions => conditions).each do |r|
      data << Pricing.make_data(r.price, get_input_from_realty(r))
    end
    puts "Generate #{data.length} rows for prediction"

    @@data_cache[conditions.hash] = data
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
end
