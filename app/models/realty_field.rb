class RealtyField < ActiveRecord::Base
  validates_presence_of :name
  
  belongs_to :realty_field_type
  belongs_to :realty_field_group
  has_many :realty_field_settings
  has_many :list_field_values
  has_many :realty_field_values
end
