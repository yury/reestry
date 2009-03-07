class CreateRealtyFieldSettings < ActiveRecord::Migration
  def self.up
    create_table :realty_field_settings do |t|
      t.integer :realty_type_id, :null => false
      t.integer :realty_field_id, :null => false
      t.integer :service_type_id
      t.boolean :required, :null => false, :default => false

      t.timestamps
    end
    
    execute "alter table realty_field_settings add constraint fk_realty_field_settings_realty_types
             foreign key (realty_type_id) references realty_types(id)"
    
    execute "alter table realty_field_settings add constraint fk_realty_field_settings_realty_fields
             foreign key (realty_field_id) references realty_fields(id)"
    
    execute "alter table realty_field_settings add constraint fk_realty_field_settings_service_types
             foreign key (service_type_id) references service_types(id)"
  end

  def self.down
    drop_table :realty_field_settings
  end
end
