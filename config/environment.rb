# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
 ENV['RAILS_ENV'] ||= 'production'

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
   config.gem "hpricot"
   config.gem "mislav-will_paginate", :source => "http://gems.github.com", :lib => "will_paginate"
   config.gem "geokit", :version => "1.4.2"
   config.gem "thoughtbot-paperclip", :lib => 'paperclip'
   config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'


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
    :session_key => '_reestry_session',
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
  config.whiny_nils = true
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

end

WillPaginate::ViewHelpers.pagination_options[:prev_label] = '◄';
WillPaginate::ViewHelpers.pagination_options[:next_label] = '►'

Geokit::Geocoders::yandex = 'AEL-TUoBAAAAnzrvMwIAO2wx34Bqga5VkBuzh8WSPsSVFfQAAAAAAAAAAACdC9WVUGKzt1u6rY35drPrYXIHZQ=='

require 'whenever'

module OpenURI
  def OpenURI.open_http(buf, target, proxy, options) # :nodoc:
    if proxy
      raise "Non-HTTP proxy URI: #{proxy}" if proxy.class != URI::HTTP
    end

    if target.userinfo && "1.9.0" <= RUBY_VERSION
      # don't raise for 1.8 because compatibility.
      raise ArgumentError, "userinfo not supported.  [RFC3986]"
    end

    require 'net/http'
    klass = Net::HTTP
    if URI::HTTP === target
      # HTTP or HTTPS
      if proxy
        klass = Net::HTTP::Proxy(proxy.host, proxy.port)
      end
      target_host = target.host
      target_port = target.port
      request_uri = target.request_uri
    else
      # FTP over HTTP proxy
      target_host = proxy.host
      target_port = proxy.port
      request_uri = target.to_s
    end

    http = klass.new(target_host, target_port)
    if target.class == URI::HTTPS
      require 'net/https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      store = OpenSSL::X509::Store.new
      store.set_default_paths
      http.cert_store = store
    end

    header = {}
    options.each {|k, v| header[k] = v if String === k }

    resp = nil
    http.start {
      req = Net::HTTP::Get.new(request_uri, header)
      if options.include? :http_basic_authentication
        user, pass = options[:http_basic_authentication]
        req.basic_auth user, pass
      end
      http.request(req) {|response|
        resp = response
        if options[:content_length_proc] && Net::HTTPSuccess === resp
          if resp.key?('Content-Length')
            options[:content_length_proc].call(resp['Content-Length'].to_i)
          else
            options[:content_length_proc].call(nil)
          end
        end
        resp.read_body {|str|
          buf << str
          if options[:progress_proc] && Net::HTTPSuccess === resp
            options[:progress_proc].call(buf.size)
          end
        }
      }
    }
    io = buf.io
    io.rewind
    io.status = [resp.code, resp.message]
    resp.each {|name,value| buf.io.meta_add_field name, value }
    case resp
    when Net::HTTPSuccess,
        Net::HTTPInternalServerError
    when Net::HTTPMovedPermanently, # 301
         Net::HTTPFound, # 302
         Net::HTTPSeeOther, # 303
         Net::HTTPTemporaryRedirect # 307
      throw :open_uri_redirect, URI.parse(resp['location'])
    else
      raise OpenURI::HTTPError.new(io.status.join(' '), io)
    end
  end
end
