# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_plugin_session',
  :secret      => '914aa1f03aaded2fa775a9254cfcd434b7ae7bb1282a63ace9d7be9a17a24d20a1d41f3c7b77652e990128c98aadfc00650fcd7a1f2d6c2d34cb33b325f65aa0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
