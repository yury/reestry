class AddCurrencies < ActiveRecord::Migration
  def self.up
    currency = Currency.create(:name => "Российский рубль", :short_name => "РУБ")
    currency.save!
    
    currency = Currency.create(:name => "Доллар США", :short_name => "USD")
    currency.save!
    
    currency = Currency.create(:name => "Евро", :short_name => "EUR")
    currency.save!
  end

  def self.down
    Currency.delete_all 
  end
end
