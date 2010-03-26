#encoding: utf-8
require 'rake'

desc "deploy on production server"
task :deploy => :environment do
  require 'rye'

  host = 'reestry.ru'
  rails_root = '/mnt/reestry'

  def gems_changed? pull_result
    pull_result.grep(/\/Gemfile/m).present?
  end

  def js_changed? pull_result
    pull_result.grep(/\/public\/javascripts\//m).present?
  end

  def css_changed? pull_result
    pull_result.grep(/\/public\/stylesheets\//m).present?
  end

  def db_changed? pull_result
    pull_result.grep(/\/db\/migrate\//m).present?
  end

  def schedule_changed? pull_result
    pull_result.grep(/\/config\/schedule\.rb/).present?
  end

  Rye::Box.class_eval do
    def env_execute(cmd)
      execute("source /etc/profile && #{cmd}")
    end
  end

  rbox = Rye::Box.new(host, :user=>'root', :safe => false)
  rbox.setenv('RAILS_ENV', 'production')
  puts "connecting to server ..."
  rbox.cd rails_root
  puts rbox.pwd

  puts "updating sources ..."
  puts pull_result = rbox.execute("git pull")

  if gems_changed? pull_result
    puts "updating gems ..."
    puts rbox.env_execute("bundle install")
  end

  if js_changed? pull_result
    puts "deleting all.js ..."
    puts rbox.execute("rm public/javascripts/all.js")
  end

  if css_changed? pull_result
    puts "deleting all.css ..."
    puts rbox.execute("rm public/stylesheets/all.css")
  end

  if db_changed? pull_result
    puts "migrating database ..."
    puts rbox.env_execute("rake db:migrate")
  end

  if schedule_changed? pull_result
    puts "updating crontab ..."
    puts rbox.env_execute("whenever --update-crontab reestry")
  end

  puts "restart delayed_job ..."
  rbox.execute("monit restart reestry_delayed_job")

  puts "upgrading unicorns..."
  rbox.execute("bin/server upgrade")
  
  puts "done."
end