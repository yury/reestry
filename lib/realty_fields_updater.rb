class RealtyFieldsUpdater
  require 'csv'

  def self.update
    realty_types_cell = 7
    is_first_row = true
    realty_types = []
    CSV.open('c:\projects\doma33\doc\realty_fields.txt', "r", "\t") do |row|
      if is_first_row
        for i in realty_types_cell...row.length
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
         irr_name = row[4].nil? ? nil : row[4].to_utf8.trim
         irr_parser = row[5].nil? ? nil : row[5].to_utf8.trim
         service_name = row[6].nil? ? "" : row[6].to_utf8.trim

         group = RealtyFieldGroup.find_by_name group_name
         group = RealtyFieldGroup.create :name => group_name if group.blank?

         service = ServiceType.find_by_name service_name
         service = ServiceType.create :name => service_name if service.blank? && !service_name.blank?

         field = RealtyField.find_by_name field_name
         field = RealtyField.create :name => field_name, :realty_field_type => field_type,
           :realty_field_group => group, :irr_name => irr_name, :irr_parser => irr_parser if field.blank?

         index = 1
         is_default = true
         list_values.split(',').each do |value|
         list_value = ListFieldValue.find_by_name_and_realty_field_id value, field.id
         list_value = ListFieldValue.create :name => value, :field_value => index, :realty_field => field, 
            :default => is_default if list_value.blank?
          
          index = index + 1
          is_default = false
         end

        RealtyFieldSetting.delete_all :realty_field_id => field.id

        for i in realty_types_cell...row.length do
          sign = row[i].nil? ? "" : row[i].to_utf8.trim
          puts "Sign:#{sign.to_win1251};Field:#{field.name.to_win1251};Type:#{realty_types[i-realty_types_cell].name.to_win1251}" unless sign.empty?
          
          RealtyFieldSetting.create(:realty_field => field,
            :service_type => service,
            :realty_type => realty_types[i-realty_types_cell],
            :required => sign == "+") unless sign.empty?
        end
      end
    end
  end

end
