class CreateRealtyPurposes < ActiveRecord::Migration
  def self.up
    create_table :realty_purposes do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :realty_purposes
  end
end
