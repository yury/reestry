require 'rake'

namespace :parse do

  desc "parses realties from sources"
  task :start => :environment  do
    puts "Start parsing at #{Time.now}"

    puts "Parsing irr..."
    result = IrrRealEstate.parse false, false
    puts "Sending email"
    AdminMailer.deliver_parse_notification "Irr", result

    puts "End parsing at #{Time.now}"

    puts "Start recalculating prices at #{Time.now}"
    Pricer.warmup
    Pricer.recalculate_prices
    puts "End recalculating prices at #{Time.now}"

    puts "Expire cache"
    Rails.cache.delete("views/footer")
  end
end