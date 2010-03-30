class Pricer
  
  cattr_reader(:version)
  
  @@version = '1.3'

  def self.predict_price realty
    start_time = Time.now

    data = get_data_for_pricing realty
    vector = get_input_from_realty realty
    
    price = Pricing.weighted_knn_estimate(data,vector) {|dist| Pricing::Weights.gaussian(dist)}

    puts "Execution time: #{Time.now - start_time}"
    price.nan? ? nil : round_price(price)
  end

  def self.round_price price
    price = price.round.to_f
    price.round(-price.round.to_s.length + 2)
  end

  def self.recalculate_prices
    realties = Realty.find(:all, :conditions => "price < 1 and predict_price is null")
    puts "Recalculate prices for #{realties.length} realties"
    counter = 0
    realties.each do |realty|
      puts "Realty: #{realty.id}"
      realty.predict_price = predict_price(realty)
      realty.save!
      counter += 1
      puts "Progress: #{counter*100/realties.length}%"
    end
    puts 'Done'
  end

  def self.analyze_algorithms
    #puts 'Analize weighted_knn_estimate algorithm (k=5) with inverse weight'
    #analyze_algorithm() { |data, vector| Pricing.weighted_knn_estimate(data,vector) {|dist| Pricing::Weights.inverse(dist)}}
    puts 'Analize weighted_knn_estimate algorithm (k=5) with subtract weight'
    analyze_algorithm() { |data, vector| Pricing.weighted_knn_estimate(data,vector) {|dist| Pricing::Weights.subtract_weight(dist)}}
    #puts 'Analize weighted_knn_estimate algorithm (k=5) with gaussian weight'
    #analyze_algorithm() { |data, vector| Pricing.weighted_knn_estimate(data,vector) {|dist| Pricing::Weights.gaussian(dist)}}
    #puts 'Analize knn_estimate algorithm (k=3)'
    #analyze_algorithm() { |data, vector| Pricing.knn_estimate(data, vector) }
  end

  def self.optimize_algorithms
     puts 'Optimize weighted_knn_estimate algorithm (k=5) with gaussian weight'
     optimize_algorithm() { |data, vector| Pricing.weighted_knn_estimate(data,vector) {|dist| Pricing::Weights.subtract_weight(dist)}}
  end

  def self.analyze_algorithm &algo
    analyze_algorithm_with_scale(nil, &algo)
  end

  def self.analyze_algorithm_with_scale scale, &algo
    overall_result = 0.0
    tries = 0
    Realty.find_by_sql("select * from realties group by service_type_id, realty_type_id").each do |realty|
      puts "Test algo for service_type=#{realty.service_type.name} and realty_type=#{realty.realty_type.name}"

      data = get_data_for_pricing(realty)
      unless scale.nil?
        puts "Scale: #{scale.inspect}"
        data = Pricing.rescale(data, scale)
      end
      
      result = Pricing.cross_validate(data, &algo)
      
      puts "Result: #{result*100}%"
      tries = tries + 1
      overall_result += result
    end

    result = overall_result*100/tries
    puts "Overall result: #{result}%"
    result
  end

  def self.optimize_algorithm &algo
    domain = [[0,20]]*get_input_from_realty(Realty.first).length

    Optimization.annealing(domain) do |scale|
      analyze_algorithm_with_scale(scale, &algo)
    end
  end

  def self.warmup
    Realty.find_by_sql("select * from realties group by service_type_id, realty_type_id").each do |realty|
      clear_cache(realty)
      get_data_for_pricing(realty)
    end
    puts 'Pricer is warm.'
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
        realty.service_type_id, realty.realty_type_id, Date.today.advance(:months => -1)]
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
    puts "Generate #{data.length} rows for prediction."

    puts "Save data to cache (#{conditions.hash})"
    set_data_to_cache(realty, data)
    data
  end

  def self.get_input_from_realty realty
    input = []
    input << (realty.total_area.blank? ? 0 : realty.total_area)
    input << 1 / (realty.distance.blank? ? 1 : realty.distance)

    RealtyField.find_by_sql(["select rf.* from realty_fields rf
                             inner join realty_field_settings rfs on rf.id = rfs.realty_field_id
                             where (service_type_id is null or service_type_id = ?)
                               and realty_type_id = ? and predict = 1",
        realty.service_type_id, realty.realty_type_id]).each do |predict_field|
      field_value = realty.realty_field_values.select {|v| v.realty_field_id == predict_field.id}.first
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
    "service_type_id = #{realty.service_type.name} and realty_type_id = #{realty.realty_type.name}".hash.to_s
  end

  def self.clear_cache realty
    Rails.cache.delete(get_data_id(realty))
  end

  def self.get_data_from_cache realty
    Rails.cache.read(get_data_id(realty))
  end

  def self.set_data_to_cache realty, data
    Rails.cache.write(get_data_id(realty), data, :expires_in => 24.hours)
  end
end
