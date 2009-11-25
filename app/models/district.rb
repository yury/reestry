class District < ActiveRecord::Base
  belongs_to :location
  has_many :realties
  
  validates_presence_of :name, :location_id

  acts_as_mappable :default_units => :kms,
                   :default_formula => :flat
end
