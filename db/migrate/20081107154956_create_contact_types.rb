class CreateContactTypes < ActiveRecord::Migration
  def self.up
    create_table :contact_types do |t|
      t.string :name
      t.string :validator
      t.string :validation_error
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_types
  end
end
