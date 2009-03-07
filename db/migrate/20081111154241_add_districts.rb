class AddDistricts < ActiveRecord::Migration
  def self.up
    l = Location.find_by_name("Владимир")
    
    d = District.new :name => "Центр", :location => l
    d.save!
    
    d = District.new :name => "Ленинский р-н", :location => l
    d.save!
    
    d = District.new :name => "Октябрьский р-н", :location => l
    d.save!
    
    d = District.new :name => "Фрунзенский р-н", :location => l
    d.save!
    
    d = District.new :name => "Доброе", :location => l
    d.save!
    
    d = District.new :name => "Юго-западный р-н", :location => l
    d.save!
    
    d = District.new :name => "Сельцо", :location => l
    d.save!
    
    d = District.new :name => "Юрьевец", :location => l
    d.save!
    
    d = District.new :name => "Другие", :location => l
    d.save!
    
    l = Location.find_by_name("Владимирская обл.")
    
    d = District.new :name => "Суздальский р-н", :location => l
    d.save!
    
    d = District.new :name => "Камешковский р-н", :location => l
    d.save!
    
    d = District.new :name => "Судогодский р-н", :location => l
    d.save!
    
    d = District.new :name => "Собинский р-н", :location => l
    d.save!
    
    d = District.new :name => "Юрьев-Польский р-н", :location => l
    d.save!
    
    d = District.new :name => "Гусь-Хрустальный р-н", :location => l
    d.save!
    
    d = District.new :name => "Вязниковский р-н", :location => l
    d.save!
    
    d = District.new :name => "Другие", :location => l
    d.save!
  end

  def self.down
    District.delete_all 
  end
end
