require 'fx/memcached_store'
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true
#config.cache_store = :mem_cache_store, { :namespace => 'reestry3' }
config.cache_store = :libmemcached_store, {:prefix_key => "reestry"}

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

config.whiny_nils = true
config.action_view.debug_rjs                         = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

config.log_level = :debug

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = true

config.action_mailer.delivery_method = :smtp

# these options are only needed if you choose smtp delivery
config.action_mailer.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'smtp.gmail.com',
  :port => 587,
  :authentication => :plain,
  :domain => "reestry.ru",
  :user_name => 'admin@reestry.ru',
  :password => 'password1'
}
