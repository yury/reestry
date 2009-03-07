class AddRealtyFieldGroups < ActiveRecord::Migration
  def self.up
    group = RealtyFieldGroup.create :name => "Основные"
    group.save!
    
    group = RealtyFieldGroup.create :name => "Оплата"
    group.save!
    
    group = RealtyFieldGroup.create :name => "Дополнительные"
    group.save!
  end

  def self.down
    RealtyFieldGroup.delete_all
  end
end
