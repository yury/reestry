class CreateDistrictStreets < ActiveRecord::Migration
  def self.up
    create_table :district_streets do |t|
      t.integer :district_id, :null=>false
      t.string :street,:null=>false

      t.timestamps
    end

    StreetsUpdater.update
  end

  def self.down
    drop_table :district_streets
  end
end
