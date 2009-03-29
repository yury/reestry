class AddRealtyFieldTypes < ActiveRecord::Migration
  def self.up
    field_type = RealtyFieldType.create :name => "list"
    field_type.save!
    
    field_type = RealtyFieldType.create :name => "bool"
    field_type.save!
    
    field_type = RealtyFieldType.create :name => "decimal"
    field_type.save!
    
    field_type = RealtyFieldType.create :name => "int"
    field_type.save!

    field_type = RealtyFieldType.create :name => "string"
    field_type.save!
  end

  def self.down
    RealtyFieldType.delete_all
  end
end
