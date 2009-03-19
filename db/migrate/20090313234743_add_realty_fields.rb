class AddRealtyFields < ActiveRecord::Migration
  
  def self.up
    RealtyFieldsUpdater.update
  end

  def self.down
    ListFieldValue.destroy_all
    RealtyFieldSetting.destroy_all
    RealtyField.destroy_all
    RealtyType.destroy_all
    RealtyPurpose.destroy_all
    ServiceType.destroy_all
  end
end
