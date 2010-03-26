#encoding: utf-8
class RealtyFieldsUpdater
  require 'csv'

  def self.update
    realty_types_cell = 8
    is_first_row = true
    realty_types = []
    CSV.foreach(Dir.getwd + "/doc/realty_fields.csv", :col_sep => "\t") do |row|
      if is_first_row
        for i in realty_types_cell...row.length
          purpose_name = row[i].split(',')[0].trim
          realty_type_name = row[i].split(',')[1].trim

          purpose = RealtyPurpose.find_by_name purpose_name
          purpose = RealtyPurpose.create :name => purpose_name if purpose.blank?

          realty_type = purpose.realty_types.find_by_name realty_type_name
          realty_type = RealtyType.create :name => realty_type_name, :realty_purpose => purpose if realty_type.blank?

          realty_types << realty_type
        end
        is_first_row = false
      else
         field_name = row[0].trim
         field_type = RealtyFieldType.find_by_name row[1].trim
         group_name = row[2].trim
         is_predict = row[3].nil? ? false : true
         list_values = row[4].nil? ? "" : row[4].trim
         irr_name = row[5].nil? ? nil : row[5].trim
         irr_parser = row[6].nil? ? nil : row[6].trim
         service_name = row[7].nil? ? "" : row[7].trim

         group = RealtyFieldGroup.find_by_name group_name
         group = RealtyFieldGroup.create :name => group_name if group.blank?

         service = ServiceType.find_by_name service_name
         service = ServiceType.create :name => service_name if service.blank? && !service_name.blank?

         field = RealtyField.find_by_name field_name
         field = RealtyField.new :name => field_name if field.blank?

         field.realty_field_type = field_type
         field.realty_field_group = group
         field.predict = is_predict

         field.irr_parsers.destroy_all

         unless irr_name.blank?
           irr_name.split(";").each do |name|
             field.irr_parsers << IrrParser.new(:name => name.strip, :parser => irr_parser)
           end
         end

         field.save!

         index = 1
         is_default = true
         list_values.split(',').each do |value_with_weight|
           value = value_with_weight.split(':')[0]
           weight = value_with_weight.split(':')[1]
           weight = 0 if weight.blank?

           list_value = ListFieldValue.find_by_name_and_realty_field_id value.trim, field.id
           list_value = ListFieldValue.new :name => value.trim, :realty_field => field if list_value.blank?
           list_value.field_value = index
           list_value.default = is_default
           list_value.weight = weight
           list_value.save!
          
           index = index + 1
           is_default = false
         end

        RealtyFieldSetting.delete_all :realty_field_id => field.id

        for i in realty_types_cell...row.length do
          sign = row[i].nil? ? "" : row[i].trim
          puts "Sign:#{sign};Field:#{field.name};Type:#{realty_types[i-realty_types_cell].name}" unless sign.empty?
          
          RealtyFieldSetting.create(:realty_field => field,
            :service_type => service,
            :realty_type => realty_types[i-realty_types_cell],
            :required => sign == "+") unless sign.empty?
        end
      end
    end
  end

end
