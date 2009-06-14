# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_db:create_session',
  :secret      => 'cb2b923bb2d824c6c4f9575b42be01c529409a0cc888d0dc1a1f5c2c6ab6553fd7d4e178078ce7e064a3247db2e86de283cd804c4947686e9d034681becb790a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
