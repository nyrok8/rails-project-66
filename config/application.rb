# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module RailsProject66
  class Application < Rails::Application
    config.load_defaults 7.2

    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :ru

    config.default_url_options = { host: ENV.fetch('BASE_URL', nil) }
  end
end
