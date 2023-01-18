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
        puts 'Factory Bot Rails Not installed!'
      end
    end

    # as of sprockets >= 4 have to explicitly declare each file
    initializer 'bpluser.assets.precompile' do |app|
      app.config.assets.precompile << 'bpluser_manifest.js'
    end
  end
end
