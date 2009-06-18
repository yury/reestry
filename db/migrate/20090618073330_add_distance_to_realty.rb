class AddDistanceToRealty < ActiveRecord::Migration
  include Geokit::Geocoders

  def self.up
    add_column :realties, :distance, :decimal, :precision => 10, :scale => 3

    center = GoogleGeocoder.geocode("Владимир,Россия")
    Realty.find_all_by_is_exact(1).each do |realty|
      realty.distance = realty.distance_to(center, :units => :kms)
      realty.save!
    end
  end

  def self.down
    remove_column(:realties, :distance)
  end
end
