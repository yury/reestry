class StreetsUpdater
  require 'csv'

  def self.update
    DistrictStreet.destroy_all

    district = ""
    CSV.open(Dir.getwd + "/doc/streets.txt", "r", "\t") do |row|
      street = row[0].to_utf8.gsub(/\(.*\)/, '').trim
      district = District.find_by_name row[1].to_utf8.trim unless row[1].nil?

      ds = DistrictStreet.find_by_street street
      DistrictStreet.create :district_id => district.id, :street => street if ds.blank?

      puts "Street:#{street.to_win1251}. District:#{district}"
    end
  end
end
