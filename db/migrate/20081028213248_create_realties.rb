class CreateRealties < ActiveRecord::Migration
  def self.up
    create_table :realties do |t|
      t.integer :service_type_id, :null => false
      t.integer :realty_type_id, :null => false
      t.string :place
      t.string :street
      t.string :number
      t.decimal :price, :null => false, :precision => 19, :scale => 2
      t.integer :currency_id, :null => false
      t.string :description
      t.decimal :total_area, :precision => 19, :scale => 2
      t.integer :area_unit_id
      t.boolean :available, :null => false, :default => true

      t.timestamps
    end
    
    execute "alter table realties add constraint fk_realty_service_types
             foreign key (service_type_id) references service_types(id)"
    
    execute "alter table realties add constraint fk_realty_realty_types
             foreign key (realty_type_id) references realty_types(id)"
    
    execute "alter table realties add constraint fk_realty_currencies
             foreign key (currency_id) references currencies(id)"
    
    execute "alter table realties add constraint fk_realty_area_units
             foreign key (area_unit_id) references area_units(id)"
  end

  def self.down
    drop_table :realties
  end
end
