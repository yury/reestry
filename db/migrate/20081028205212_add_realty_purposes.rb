class AddRealtyPurposes < ActiveRecord::Migration
  def self.up
    purpose = RealtyPurpose.create(:name => "Жилое")
    purpose.save!
    
    purpose = RealtyPurpose.create(:name => "Коммерческое")
    purpose.save!
    
    purpose = RealtyPurpose.create(:name => "Другое")
    purpose.save!
  end

  def self.down
    RealtyPurpose.delete_all
  end
end
