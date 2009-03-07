class ListFieldValue < ActiveRecord::Base
  validates_presence_of :realty_field_id, :field_value, :name
  
  belongs_to :realty_field
end
