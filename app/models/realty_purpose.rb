class RealtyPurpose < ActiveRecord::Base
  validates_presence_of :name
  
  has_many :realty_types
end
