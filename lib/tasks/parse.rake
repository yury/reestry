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

    begin
      puts "Start recalculating prices at #{Time.now}"
      Pricer.warmup
      Pricer.recalculate_prices
      puts "End recalculating prices at #{Time.now}"
    rescue Exception => exc
      body = "#{exc.inspect}#{exc.backtrace.join('\n')}"
      AdminMailer.deliver_error_notification "Recalculating prices", body
      Pricer.recalculate_prices
    end

    puts "Expire cache"
    Rails.cache.delete("views/footer")
  end
end
