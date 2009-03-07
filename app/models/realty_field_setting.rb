class RealtyFieldSetting < ActiveRecord::Base
  belongs_to :realty_field
  belongs_to :realty_type
  belongs_to :service_type
  
  def realty_field_value realty
    value = self.realty_field.realty_field_values.find_by_realty_id(realty.id)
    if !value.blank?
      value.decimal_value
    end
  end

  def field_group
    realty_field.realty_field_group
  end
end
