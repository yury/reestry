class RealtyFieldType < ActiveRecord::Base
  validates_presence_of :name
  
  has_many :realty_fields

  def list?
    name == 'list'
  end

  def bool?
    name == 'bool'
  end

  def decimal?
    name == 'decimal'
  end

  def int?
    name == 'int'
  end

  def string?
    name == 'string'
  end
end
