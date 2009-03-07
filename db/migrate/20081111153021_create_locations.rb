class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name, :null => false
      t.boolean :is_place, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
