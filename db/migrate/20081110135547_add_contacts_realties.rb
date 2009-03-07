class AddContactsRealties < ActiveRecord::Migration
  def self.up
    create_table :contacts_realties, :id => false, :primary_key => [:contact_id, :realty_id] do |t| 
      t.integer :contact_id, :null => false
      t.integer :realty_id, :null => false
      
      t.timestamps
    end
    
    execute "alter table contacts_realties add constraint fk_contacts_realties_contacts
             foreign key (contact_id) references contacts(id)"
    
    execute "alter table contacts_realties add constraint fk_contacts_realties_realties
             foreign key (realty_id) references realties(id)"
  end

  def self.down
    drop_table :contacts_realties
  end
end
