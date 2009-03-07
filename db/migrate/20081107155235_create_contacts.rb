class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :contact_type_id, :null => false
      t.integer :user_id, :null => false
      t.string :value
      
      t.timestamps
    end
    
    execute "alter table contacts add constraint fk_contacts_contact_types
             foreign key (contact_type_id) references contact_types(id)"
    
    execute "alter table contacts add constraint fk_contacts_users
             foreign key (user_id) references users(id)"

  end

  def self.down
    drop_table :contacts
  end
end
