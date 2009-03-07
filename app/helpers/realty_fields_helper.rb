module RealtyFieldsHelper
  def realty_type_exists realty_field, realty_type
    realty_field.realty_field_settings.exists?(:realty_type_id => realty_type.id)
  end
  
  def get_service_type_id realty_field, realty_type
    setting = realty_field.realty_field_settings.find_by_realty_type_id(realty_type.id)
    if setting && setting.service_type
      setting.service_type.id
    end
  end
end
