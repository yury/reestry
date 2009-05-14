class AddPredictToRealtyFields < ActiveRecord::Migration
  def self.up
    add_column :realty_fields, :predict, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :realty_fields, :predict
  end
end
