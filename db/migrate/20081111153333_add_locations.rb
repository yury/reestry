class AddLocations < ActiveRecord::Migration
  def self.up
    l = Location.new :name => "Владимир", :is_place => true
    l.save!
    
    l = Location.new :name => "Владимирская обл."
    l.save!
  end

  def self.down
    Location.delete_all 
  end
end
