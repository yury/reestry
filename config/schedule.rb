@rails_root = File.expand_path('..', __FILE__)
set :path, @rails_root
set :environment, :production
env "LANG", "en_US.UTF-8"
env "TZ", "Europe/Moscow"

def run cmd
  command "#{@rails_root}/bin/run #{cmd}"
end

every 1.days, :at => '2:01am' do
  run "rake parse:start"
end