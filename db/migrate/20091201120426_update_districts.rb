class UpdateDistricts < ActiveRecord::Migration
  def self.up
    DistrictsUpdater.update
  end

  def self.down
  end
end
