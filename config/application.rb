require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module Redmine
  class Application < Rails::Application
    config.load_defaults 5.1
    config.active_record.default_timezone = :local
    config.time_zone = "Asia/Ho_Chi_Minh"
    config.i18n.default_locale = :vi
  end
end
