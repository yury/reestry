class District < ActiveRecord::Base
  include Fx::Math

  belongs_to :location
  has_many :realties
  
  validates_presence_of :name, :location_id

  serialize :border_polygon

  def self.find_by_realty realty
    if realty.is_exact
      District.all.each do |d|
        puts d.name
        return d if d.contains? realty
      end
    end

    District.find_by_name('Не определен')
  end

  def contains? realty
    point_in_polygon?(realty.lng, realty.lat, border_polygon)
  end
end
