class AddRealtyDistrict < ActiveRecord::Migration
  def self.up
    Realty.destroy_all

    add_column :realties, :district_id, :integer, :null => false
  end

  def self.down
    Realty.destroy_all
    
    remove_column :realties, :district_id
  end
end
