require_relative 'boot'

require 'rails/all'

# NameError solution  (mount error)
require 'carrierwave'
require 'carrierwave/orm/activerecord'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HancoRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    #서울 시간대로 조정
    config.time_zone = 'Seoul'
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
