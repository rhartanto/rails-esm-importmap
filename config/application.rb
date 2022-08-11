require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsWithEs6
  class Application < Rails::Application
    # need this line so we can run ./bin/rails importmap:install using ruby 2.6
    # https://github.com/rails/importmap-rails/issues/47
    attr_accessor :importmap

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    #
    # Enable the asset pipeline
    config.assets.enabled = true

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.svg *.swf *.map *.otf *.eot *.ttf *.woff *.woff2)

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Rhe path that assets are served from
    config.assets.prefix = "/assets"

    config.assets.initialize_on_precompile = false
  end
end
