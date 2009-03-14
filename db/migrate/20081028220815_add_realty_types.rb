class AddRealtyTypes < ActiveRecord::Migration
  def self.up
  end

  def self.down
    RealtyType.delete_all
  end
end
