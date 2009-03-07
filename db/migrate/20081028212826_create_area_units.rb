class CreateAreaUnits < ActiveRecord::Migration
  def self.up
    create_table :area_units do |t|
      t.string :name, :null => false
      t.string :short_name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :area_units
  end
end
