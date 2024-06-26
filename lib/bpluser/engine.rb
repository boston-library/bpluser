# frozen_string_literal: true

begin
  require 'recaptcha'
rescue LoadError => e
  puts "A Gem Dependency is Missing....#{e.message}"
end

module Bpluser
  class Engine < ::Rails::Engine
    isolate_namespace Bpluser

    if %w[development test].member?(Rails.env) && Dir[File.expand_path('../../spec/**', __dir__)].any? { |d| d.include?('dummy') }
      begin
        require 'factory_bot_rails'
        config.factory_bot.definition_file_paths << File.expand_path('../../spec/factories/bpluser', __dir__)
      rescue LoadError
        warn 'Factory Bot Rails Not installed!'
      end

      config.generators do |g|
        g.orm :active_record
        g.test_framework :rspec, fixture: true
        g.fixture_replacement :factory_bot
        g.factory_bot dir: 'spec/factories'
      end
    end

    # initializer 'bpluser.add_devise_guests_overrides', before: 'devise_guests.add_helpers' do
    #   DeviseGuests::Controllers::Helpers.include(Bpluser::DeviseGuestsOverride)
    # end

    # as of sprockets >= 4 have to explicitly declare each file
    initializer 'bpluser.assets.precompile' do |app|
      app.config.assets.precompile << 'bpluser_manifest.js'
    end
  end
end
