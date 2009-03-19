class CreateRealtyFields < ActiveRecord::Migration
  def self.up
    create_table :realty_fields do |t|
      t.string  :name, :null => false
      t.integer :realty_field_type_id, :null => false
      t.integer :realty_field_group_id, :null => false
      t.boolean :searchable, :null => false, :default => true
      t.string  :irr_name
      t.string  :irr_parser
      
      t.timestamps
    end
    
    execute "alter table realty_fields add constraint fk_realty_fields_realty_field_types
             foreign key (realty_field_type_id) references realty_field_types(id)"
    
    execute "alter table realty_fields add constraint fk_realty_fields_realty_field_groups
             foreign key (realty_field_group_id) references realty_field_groups(id)"
  end

  def self.down
    drop_table :realty_fields
  end
end
