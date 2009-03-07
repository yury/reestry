class AddRealtyFields < ActiveRecord::Migration
  def self.up
    main_group = RealtyFieldGroup.find_by_name "Основные"
    pay_group = RealtyFieldGroup.find_by_name "Оплата"
    additional_group = RealtyFieldGroup.find_by_name "Дополнительные"
    list_type = RealtyFieldType.find_by_name "list"
    bool_type = RealtyFieldType.find_by_name "bool"
    decimal_type = RealtyFieldType.find_by_name "decimal"
    int_type = RealtyFieldType.find_by_name "int"
    live_purpose = RealtyPurpose.find_by_name "Жилое"
    live_flat = live_purpose.realty_types.find_by_name "Квартира"
    live_room = live_purpose.realty_types.find_by_name "Комната"
    lease_service = ServiceType.find_by_name "Аренда"
    
    field = RealtyField.create :name => "Планировка", :realty_field_type => list_type,
      :realty_field_group => main_group
    field.realty_field_settings << RealtyFieldSetting.new(:realty_type => live_flat)
    field.realty_field_settings << RealtyFieldSetting.new(:realty_type => live_room)
    field.save!
    
    field = RealtyField.create :name => "Количество комнат", :realty_field_type => list_type,
      :realty_field_group => main_group
    field.save!
    
    field = RealtyField.create :name => "Оплата коммунальных услуг входит в цену", :realty_field_type => bool_type,
      :realty_field_group => pay_group
    field.realty_field_settings << RealtyFieldSetting.new(:service_type => lease_service, :realty_type => live_flat)
    field.realty_field_settings << RealtyFieldSetting.new(:service_type => lease_service, :realty_type => live_room)
    field.save!
    
    field = RealtyField.create :name => "Оплата электричества входит в цену", :realty_field_type => bool_type,
      :realty_field_group => pay_group
    field.realty_field_settings << RealtyFieldSetting.new(:service_type => lease_service, :realty_type => live_flat)
    field.realty_field_settings << RealtyFieldSetting.new(:service_type => lease_service, :realty_type => live_room)
    field.save!
    
    field = RealtyField.create :name => "Регламент оплаты", :realty_field_type => list_type,
      :realty_field_group => pay_group
    field.save!
    
    field = RealtyField.create :name => "Жилая площадь", :realty_field_type => decimal_type,
      :realty_field_group => main_group
    field.save!
    
    field = RealtyField.create :name => "Наличие балкона", :realty_field_type => bool_type,
      :realty_field_group => additional_group
    field.save!
    
    field = RealtyField.create :name => "Год постройки", :realty_field_type => int_type,
      :realty_field_group => additional_group
    field.save!
  end

  def self.down
    RealtyFieldSetting.delete_all  
    RealtyField.delete_all
  end
end
