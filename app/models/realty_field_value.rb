class RealtyFieldValue < ActiveRecord::Base
  belongs_to :realty
  belongs_to :realty_field
  
  def string_value
    type = self.realty_field.realty_field_type.name
    if type == "list"
      list_field = self.realty_field.list_field_values.find(self.value)
      list_field ? list_field.name : "" 
    elsif type != "bool"
      self.value
    end
  end
  
  def string_value_with_name
    self.realty_field.name + (string_value.blank? ? "" : ": #{string_value}")
  end
  
  def field_group
    realty_field.realty_field_group
  end
end
