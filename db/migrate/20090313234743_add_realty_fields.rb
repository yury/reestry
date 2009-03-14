class AddRealtyFields < ActiveRecord::Migration
  require 'csv'
  def self.up
    is_first_row = true
    realty_types = []
    CSV.open('c:\projects\doma33\doc\realty_fields.txt', "r", "\t") do |row|
      if is_first_row
        for i in 5...row.length
          purpose_name = row[i].split(',')[0].to_utf8.trim
          realty_type_name = row[i].split(',')[1].to_utf8.trim

          purpose = RealtyPurpose.find_by_name purpose_name
          purpose = RealtyPurpose.create :name => purpose_name if purpose.blank?

          realty_type = purpose.realty_types.find_by_name realty_type_name
          realty_type = RealtyType.create :name => realty_type_name, :realty_purpose => purpose

          realty_types << realty_type
        end
        is_first_row = false
      else
         field_name = row[0].to_utf8.trim
         field_type = RealtyFieldType.find_by_name row[1].to_utf8.trim
         group_name = row[2].to_utf8.trim
         list_values = row[3].nil? ? "" : row[3].to_utf8.trim
         service_name = row[4].nil? ? "" : row[4].to_utf8.trim
         
         group = RealtyFieldGroup.find_by_name group_name
         group = RealtyFieldGroup.create :name => group_name if group.blank?
         
         service = ServiceType.find_by_name service_name
         service = ServiceType.create :name => service_name if service.blank? && !service_name.blank?

         field = RealtyField.create :name => field_name, :realty_field_type => field_type, :realty_field_group => group

         index = 1
         is_default = true
         list_values.split(',').each do |value|
          list_value = ListFieldValue.create :name => value, :field_value => index, :realty_field => field, :default => is_default
          index = index + 1
          is_default = false
         end

        for i in 5...row.length do
          sign = row[i].nil? ? "" : row[i].to_utf8.trim
          puts "Sign:#{sign.to_win1251};Field:#{field.name.to_win1251};Type:#{realty_types[i-5].name.to_win1251}" unless sign.empty?
          RealtyFieldSetting.create(:realty_field => field,
            :service_type => service,
            :realty_type => realty_types[i-5],
            :required => sign == "+") unless sign.empty?
        end
      end
    end
  end

  def self.upold
    

    field = RealtyField.create :name => "Планировка", :realty_field_type => list_type, :realty_field_group => main_group
    list_value = ListFieldValue.create :name => "Хрущовка",    :field_value => 1, :realty_field => field, :default => true
    list_value = ListFieldValue.create :name => "Сталинка",    :field_value => 2, :realty_field => field
    list_value = ListFieldValue.create :name => "Брежневка",   :field_value => 3, :realty_field => field
    list_value = ListFieldValue.create :name => "Малосемейка", :field_value => 4, :realty_field => field
    list_value = ListFieldValue.create :name => "Улучшенная",  :field_value => 5, :realty_field => field
    list_value = ListFieldValue.create :name => "Студия",      :field_value => 6, :realty_field => field

    field.realty_field_settings << RealtyFieldSetting.new(:realty_type => live_flat)
    field.realty_field_settings << RealtyFieldSetting.new(:realty_type => live_room)
    field.realty_field_settings << RealtyFieldSetting.new(:realty_type => comm_flat)
    field.save!

    field = RealtyField.create :name => "Количество комнат", :realty_field_type => list_type, :realty_field_group => main_group
    list_value = ListFieldValue.create :name => "1",    :field_value => 1, :realty_field => field, :default => true
    list_value = ListFieldValue.create :name => "2",    :field_value => 2, :realty_field => field
    list_value = ListFieldValue.create :name => "3",   :field_value => 3, :realty_field => field
    list_value = ListFieldValue.create :name => "4", :field_value => 4, :realty_field => field
    list_value = ListFieldValue.create :name => "5",  :field_value => 5, :realty_field => field
    list_value = ListFieldValue.create :name => "6 и более",      :field_value => 6, :realty_field => field

    field.realty_field_settings << RealtyFieldSetting.new(:realty_type => live_flat)
    field.save!

    field = RealtyField.create :name => "Оплата коммунальных услуг входит в цену", :realty_field_type => bool_type, :realty_field_group => pay_group
    field.realty_field_settings << RealtyFieldSetting.new(:service_type => lease_service, :realty_type => live_flat)
    field.realty_field_settings << RealtyFieldSetting.new(:service_type => lease_service, :realty_type => live_room)
    field.save!

    field = RealtyField.create :name => "Оплата электричества входит в цену", :realty_field_type => bool_type, :realty_field_group => pay_group
    field.realty_field_settings << RealtyFieldSetting.new(:service_type => lease_service, :realty_type => live_flat)
    field.realty_field_settings << RealtyFieldSetting.new(:service_type => lease_service, :realty_type => live_room)
    field.save!

    field = RealtyField.create :name => "Регламент оплаты", :realty_field_type => list_type, :realty_field_group => pay_group
    field.save!

    field = RealtyField.create :name => "Жилая площадь", :realty_field_type => decimal_type, :realty_field_group => main_group
    field.save!

    field = RealtyField.create :name => "Наличие балкона", :realty_field_type => bool_type, :realty_field_group => additional_group
    field.save!

    field = RealtyField.create :name => "Год постройки", :realty_field_type => int_type, :realty_field_group => additional_group
    field.save!
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
