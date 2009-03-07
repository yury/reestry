class CreateRealtyFieldValues < ActiveRecord::Migration
  def self.up
    create_table :realty_field_values do |t|
      t.integer :realty_id, :null => false
      t.integer :realty_field_id, :null => false
      t.decimal :decimal_value, :precision => 19, :scale => 2

      t.timestamps
    end
    
    execute "alter table realty_field_values add constraint fk_realty_field_values_realty_fields
             foreign key (realty_field_id) references realty_fields(id)"
    
    execute "alter table realty_field_values add constraint fk_realty_field_values_realties
             foreign key (realty_id) references realties(id)"
  end

  def self.down
    drop_table :realty_field_values
  end
end
