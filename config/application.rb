require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module CacheDemo
  class Application < Rails::Application
    config.load_defaults 5.2

    config.api_only = true
  end
end
