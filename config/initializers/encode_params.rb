require 'fx/unicode_enforcer'

ActionController::Dispatcher.middleware.insert_after(
  ActionController::ParamsParser,
  Fx::UnicodeEnforcer
)