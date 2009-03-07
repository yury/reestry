class RealtyFieldType < ActiveRecord::Base
  validates_presence_of :name
  
  has_many :realty_fields
end
