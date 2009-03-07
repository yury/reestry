class RealtyType < ActiveRecord::Base
  validates_presence_of :name
  
  belongs_to :realty_purpose
  has_many :realty
end
