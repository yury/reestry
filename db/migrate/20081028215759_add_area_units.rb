#encoding: utf-8
class AddAreaUnits < ActiveRecord::Migration
  def self.up
    area_unit = AreaUnit.create :name => "Квадратный метр", :short_name => "м²"
    area_unit.save!
    
    area_unit = AreaUnit.create :name => "Сотка", :short_name => "сот"
    area_unit.save!
    
    area_unit = AreaUnit.create :name => "Гектар", :short_name => "га"
    area_unit.save!
  end

  def self.down
    AreaUnit.delete_all
  end
end
