class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :name, :null => false
      t.string :short_name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end
