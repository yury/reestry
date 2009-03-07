class AddContactTypes < ActiveRecord::Migration
  def self.up
    contact_type = ContactType.create :name => "Контактное лицо", 
                                      :validator => ".+",
                                      :validation_error => "Контактное лицо не может быть пустым",
                                      :rank => 0
    contact_type.save!
    
    contact_type = ContactType.create :name => "Телефон", 
                                      :validator => "(\d|\-)+",
                                      :validation_error => "Телефон может содержать только символы 0-9 и '-'",
                                      :rank => 1
    contact_type.save!
    
    contact_type = ContactType.create :name => "Моб. телефон", 
                                      :validator => "(\d|\-)+",
                                      :validation_error => "Моб. телефон может содержать только символы 0-9 и '-'",
                                      :rank => 2
    contact_type.save!
    
    contact_type = ContactType.create :name => "Факс", 
                                      :validator => "(\d|\-)+",
                                      :validation_error => "Факс может содержать только символы 0-9 и '-'",
                                      :rank => 3
    contact_type.save!
    
    contact_type = ContactType.create :name => "ICQ", 
                                      :validator => "(\d|\-)+",
                                      :validation_error => "ICQ-номер может содержать только символы 0-9 и '-'",
                                      :rank => 4
    contact_type.save!
    
    contact_type = ContactType.create :name => "Email", 
                                      :validator => "\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b",
                                      :validation_error => "Неверный email-адрес",
                                      :rank => 5
    contact_type.save!
  end

  def self.down
    Contact.delete_all
    ContactType.destroy_all
  end
end
