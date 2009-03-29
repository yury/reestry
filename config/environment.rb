# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  # config.gem "mbleigh-acts-as-taggable-on", :source => "http://gems.github.com", :lib => "acts-as-taggable-on"
  #config.gem "mislav-will_paginate", :source => "http://gems.github.com", :lib => "will_paginate"


  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_doma33_session',
    :secret      => '12657f21d0b8be229bc0a14d6582614f8dd6d6cba2662df900e5689a6bb07e024bbb6da91b560c5ed2d4901b46bc533ef0563ad13ff4edf64a950f54aa75d00c'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.gem "geokit"
end

#class PaginationListLinkRenderer < WillPaginate::LinkRenderer
#
#  def to_html
#    links = @options[:page_links] ? windowed_links : []
#
#    links.unshift(page_link_or_span(@collection.previous_page, 'previous', @options[:previous_label]))
#    links.push(page_link_or_span(@collection.next_page, 'next', @options[:next_label]))
#
#    html = links.join(@options[:separator])
#    @options[:container] ? @template.content_tag(:ul, html, html_attributes) : html
#  end
#
#protected
#
#  def windowed_links
#    visible_page_numbers.map { |n| page_link_or_span(n, (n == current_page ? 'current' : nil)) }
#  end
#
#  def page_link_or_span(page, span_class, text = nil)
#    text ||= page.to_s
#    if page && page != current_page
#      page_link(page, text, :class => span_class)
#    else
#      page_span(page, text, :class => span_class)
#    end
#  end
#
#  def page_link(page, text, attributes = {})
#    @template.content_tag(:li, @template.link_to(text, url_for(page)), attributes)
#  end
#
#  def page_span(page, text, attributes = {})
#    @template.content_tag(:li, text, attributes)
#  end
#
#end

Workling::Remote.dispatcher = Workling::Remote::Runners::BackgroundjobRunner.new
Workling::Return::Store.instance = Workling::Return::Store::MemoryReturnStore.new

WillPaginate::ViewHelpers.pagination_options[:prev_label] = '◄';
WillPaginate::ViewHelpers.pagination_options[:next_label] = '►'
