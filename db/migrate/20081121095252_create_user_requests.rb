class CreateUserRequests < ActiveRecord::Migration
  def self.up
    create_table :user_requests do |t|
      t.integer :user_id, :null => false
      t.boolean :active, :default => true, :null => false
      t.integer :service_type_id
      t.integer :location_id
      t.integer :district_id
      t.integer :realty_type_id
      t.string  :place
      t.string  :street
      t.string  :number
      t.decimal :price_from, :precision => 19, :scale => 2
      t.decimal :price_to, :precision => 19, :scale => 2
      t.decimal :total_area_from, :precision => 19, :scale => 2
      t.decimal :total_area_to, :precision => 19, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :user_requests
  end
end
