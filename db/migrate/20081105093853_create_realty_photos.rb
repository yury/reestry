class CreateRealtyPhotos < ActiveRecord::Migration
  def self.up
    create_table :realty_photos do |t|
      t.integer :realty_id, :null => false
      t.timestamps
    end
    
    execute "alter table realty_photos add constraint fk_realty_photos_realties
             foreign key (realty_id) references realties(id)"
  end

  def self.down
    drop_table :realty_photos
  end
end
