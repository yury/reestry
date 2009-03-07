class CreateDistricts < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.string :name, :null => false
      t.integer :location_id, :null => false

      t.timestamps
    end
    
    execute "alter table districts add constraint fk_districts_locations
             foreign key (location_id) references locations(id)"
  end

  def self.down
    drop_table :districts
  end
end
