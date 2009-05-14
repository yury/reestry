class AddWeightToListFieldValues < ActiveRecord::Migration
  def self.up
    add_column :list_field_values, :weight, :decimal, :default => 0, :null => false
  end

  def self.down
    remove_column :list_field_values, :weight
  end
end
