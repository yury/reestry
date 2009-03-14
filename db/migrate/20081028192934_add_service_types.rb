class AddServiceTypes < ActiveRecord::Migration
  def self.up
  end

  def self.down
    ServiceType.delete_all  
  end
end
