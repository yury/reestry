class AddBorderPolygonToDistrict < ActiveRecord::Migration
  def self.up
    add_column :districts, :border_polygon, :text
  end

  def self.down
    remove_column(:districts, :border_polygon)
  end
end
