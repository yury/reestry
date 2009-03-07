class AddServiceTypes < ActiveRecord::Migration
  def self.up
    type = ServiceType.create(:name => "Аренда")
    type.save!
    type = ServiceType.create(:name => "Продажа")
    type.save!
  end

  def self.down
    ServiceType.delete_all  
  end
end
