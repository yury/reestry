class AddRealtyTypes < ActiveRecord::Migration
  def self.up
    purpose = RealtyPurpose.find_by_name("Жилое")
    
    type = RealtyType.create :name => "Квартира", :realty_purpose => purpose
    type.save!
    
    type = RealtyType.create :name => "Комната", :realty_purpose => purpose
    type.save!
    
    type = RealtyType.create :name => "Дом", :realty_purpose => purpose
    type.save!
    
    type = RealtyType.create :name => "Дача", :realty_purpose => purpose
    type.save!
    
    type = RealtyType.create :name => "Участок", :realty_purpose => purpose
    type.save!
    
    purpose = RealtyPurpose.find_by_name("Коммерческое")
    
    type = RealtyType.create :name => "Квартира", :realty_purpose => purpose
    type.save!
    
    type = RealtyType.create :name => "Помещение", :realty_purpose => purpose
    type.save!
    
    type = RealtyType.create :name => "Здание", :realty_purpose => purpose
    type.save!
    
    purpose = RealtyPurpose.find_by_name("Другое")
    
    type = RealtyType.create :name => "Гараж", :realty_purpose => purpose
    type.save!
  end

  def self.down
    RealtyType.delete_all
  end
end
