module RealtiesHelper
  include UsersHelper

  def map realties, options = {}
    options = options.reverse_merge!(:map_type => false, :small_zoom => true, :large_map => false, :width => 300, :height => 400)
    if realties.is_a?(Array)
      options = options.merge(:realties => realties)
    else
      options = options.merge(:realties => [realties])
    end

    render :partial=>"realties/map", :locals => options
  end

  def get_description realty
    d = []
    d << realty.realty_type.name
    d << get_total_area(realty) unless realty.total_area.blank?

    realty.realty_field_values.group_by(&:field_group).each do |group, values |
      for value in values
        d << value.string_value_with_name
      end
    end

    d = d.join(", ")
  end

  def get_address realty
    a = ""
    a << "#{realty.place}, " unless realty.place.blank? || realty.district.location.is_place
    a << "ул. #{realty.street}"
    a << ", #{realty.number}" unless realty.number.blank?
    a
  end
  
  def get_full_price realty
    "#{realty.price} #{realty.currency.short_name}"
  end
  
  def get_total_area realty
    a = ""
    a << "#{realty.total_area}" unless realty.total_area.blank?
    a << " #{realty.area_unit.short_name}" unless realty.total_area.blank?
    a
  end
  
  def get_realty_field_settings_for realty_type_id, service_type_id
    RealtyFieldSetting.find_all_by_realty_type_id(realty_type_id).select do |s|
      s.service_type == nil || s.service_type_id == service_type_id
    end
  end
  
  def get_realty_field_setting_groups realty
    return [] if realty.realty_type.nil?
    
    get_realty_field_setting_groups_for(realty.realty_type.id, realty.service_type.id)
  end

  def get_realty_field_setting_groups_for realty_type_id, service_type_id
    get_realty_field_settings_for(realty_type_id, service_type_id).sort_by{|s| s.field_group.id}.group_by(&:field_group)
  end
  
    def get_list_field_values setting
      ListFieldValue.find_all_by_realty_field_id(setting.realty_field.id)
    end
    
    def get_realty_field_name setting, suffix = ""
      "f#{suffix}[#{setting.realty_field.id}]"
    end

end
