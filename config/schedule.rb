set :path, '/mnt/reestry'
set :environment, :production

every 1.days, :at => '2:01am' do
  rake "parse:start >> /tmp/rake.log"
end
