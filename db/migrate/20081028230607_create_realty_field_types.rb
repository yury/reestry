class CreateRealtyFieldTypes < ActiveRecord::Migration
  def self.up
    create_table :realty_field_types do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :realty_field_types
  end
end
