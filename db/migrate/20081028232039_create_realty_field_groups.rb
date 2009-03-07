class CreateRealtyFieldGroups < ActiveRecord::Migration
  def self.up
    create_table :realty_field_groups do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :realty_field_groups
  end
end
