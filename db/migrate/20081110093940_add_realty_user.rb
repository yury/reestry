class AddRealtyUser < ActiveRecord::Migration
  def self.up
    RealtyPhoto.delete_all
    RealtyFieldValue.delete_all
    Realty.delete_all
    add_column :realties, :user_id, :integer, :null => false
  end

  def self.down
    remove_column :realties, :user_id
  end
end
