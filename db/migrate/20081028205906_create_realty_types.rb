class CreateRealtyTypes < ActiveRecord::Migration
  def self.up
    create_table :realty_types do |t|
      t.string :name, :null => false
      t.integer :realty_purpose_id, :null => false

      t.timestamps
    end
    
    execute "alter table realty_types add constraint fk_realty_type_realty_purpose
             foreign key (realty_purpose_id) references realty_purposes(id)"
  end

  def self.down
    drop_table :realty_types
  end
end
