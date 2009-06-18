class AddPredictPriceToRealty < ActiveRecord::Migration
  def self.up
    add_column :realties, :predict_price, :decimal, :precision => 19, :scale => 2
  end

  def self.down
    remove_column(:realties, :predict_price)
  end
end
