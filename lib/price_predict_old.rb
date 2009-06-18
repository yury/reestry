module PricePredict

  def knn_estimate data, vec1, k=3
    d_list = get_distances(data, vec1)
    avg = 0.0

    for i in 0...k
      avg += data[d_list[i][1]][:result]
    end

    avg/k
  end

  def weightedknn(data, vec1, k=5)
    d_list = get_distances(data, vec1)
    avg = 0.0
    total_weight = 0.0

    for i in 0..k
      dist = d_list[i][0]
      idx = d_list[i][1]
      weight = gaussian(dist)
      avg += weight*data[idx][:result]
      total_weight += weight
    end

    avg/total_weight
  end

  def get_distances data, vec1
    distance_list = []
    for i in 0...data.length
      vec2 = data[i][:input]
      distance_list << [euclidean(vec1, vec2), i]
    end
    distance_list.sort
  end

  def euclidean v1, v2
    d = 0.0
    for i in 0...v1.length
      d += (v1[i] - v2[i])**2
    end
    Math.sqrt(d)
  end

  def gaussian(dist, sigma=1.0)
    Math.exp(-dist**2/(2*sigma**2))
  end

  def rescale(data, scale)
    scaled_data = []
    data.each do |row|
      scaled = []
      for i in 0...scale.length
        scaled << scale[i] * row[:input][i]
      end
      scaled_data << scaled
    end
    scaled_data
  end

  def dividedata(data, test=0.05)
    trainset = []
    testset = []
    data.each do |row|
      if rand()<test
        testset << row
      else
        trainset << row
      end
    end
    [trainset, testset]
  end

  def testalgorithm(trainset, testset, &block)
    error = 0.0

    testset.each do |row|
      guess = block.call(trainset, row[:input])
      error += (row[:result] - guess)**2
    end
    error/testset.length
  end

  def crossvalidate(data, trials=100, test=0.05, &block)
    error = 0.0
    for i in 0..trials
      sets = dividedata(data, test)
      error += testalgorithm(sets[0], sets[1], &block)
    end
    error/trials
  end

  def costf(data, scale)
    
    sdata = rescale(data, scale)
    crossvalidate()
  end

  def gen_data
    rows = []
    for i in 0...300
      rows << gen_row
    end
    rows
  end

  def gen_row
    {:input => [rand_value(10), rand_value(10), rand_value(10), rand_value(100), rand_value(1000)], :result => 10000 + rand_value(1000)}
  end

  def rand_value multiplier
    (rand*multiplier).round
  end
end