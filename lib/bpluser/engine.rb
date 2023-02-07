# frozen_string_literal: true

module Bpluser
  class Engine < ::Rails::Engine
    isolate_namespace Bpluser

    config.generators do |g|
      g.orm :active_record
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    if Rails.env.development? || Rails.env.test?
      begin
        require 'factory_bot_rails'
        config.factory_bot.definition_file_paths << File.expand_path('../../spec/factories/bpluser', __dir__)
      rescue LoadError
        warn 'Factory Bot Rails Not installed!'
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
