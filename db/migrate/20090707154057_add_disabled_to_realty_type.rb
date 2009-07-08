class AddDisabledToRealtyType < ActiveRecord::Migration
  def self.up
    add_column :realty_purposes, :disabled, :boolean, :null => false, :default => false

    purpose = RealtyPurpose.find_by_name("Коммерческое")
    purpose.disabled = true
    purpose.save!
  end

  def self.down
    remove_column(:realty_purposes, :disabled)
  end
end
