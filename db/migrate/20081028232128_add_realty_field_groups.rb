class AddRealtyFieldGroups < ActiveRecord::Migration
  def self.up
  end

  def self.down
    RealtyFieldGroup.delete_all
  end
end
