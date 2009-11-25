class AddGeoPointsToDistricts < ActiveRecord::Migration
  def self.up
    add_column :districts, :lat, :float
    add_column :districts, :lng, :float
  end

  def self.down
    remove_column :districts, :lat
    remove_column :districts, :lng
  end
end
