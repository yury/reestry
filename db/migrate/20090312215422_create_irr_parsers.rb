class CreateIrrParsers < ActiveRecord::Migration
  def self.up
    create_table :irr_parsers do |t|
      t.integer :realty_field_id, :null => false
      t.string  :name, :null => false
      t.string  :parser
      t.timestamps
    end
  end

  def self.down
    drop_table :irr_parsers
  end
end
