class AddExpireAtToRealty < ActiveRecord::Migration
  def self.up
    add_column :realties, :expire_at, :datetime

    Realty.all.each do |r|
      r.expire_at = r.created_at.advance(:months => 1)
      r.save!
    end
  end

  def self.down
    remove_column :realties, :expire_at
  end
end
