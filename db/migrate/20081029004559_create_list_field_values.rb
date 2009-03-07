class CreateListFieldValues < ActiveRecord::Migration
  def self.up
    create_table :list_field_values do |t|
      t.integer :realty_field_id, :null => false
      t.string :name, :null => false
      t.integer :field_value, :null => false
      t.boolean :default, :null => false, :default => false
      
      t.timestamps
    end
    
    execute "alter table list_field_values add constraint fk_list_field_values_realty_fields
             foreign key (realty_field_id) references realty_fields(id)"
  end

  def self.down
    drop_table :list_field_values
  end
end
