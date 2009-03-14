class AddRealtyPurposes < ActiveRecord::Migration
  def self.up
  end

  def self.down
    RealtyPurpose.delete_all
  end
end
