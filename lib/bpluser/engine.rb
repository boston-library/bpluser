# frozen_string_literal: true

begin
  require 'blacklight'
  require 'base64'
  require 'cgi'
  require 'openssl'
  require 'active_support/concern' unless defined? ActiveSupport::Concern
  require 'devise'
  require 'devise-guests'
  require 'omniauth'
  require 'omniauth-polaris'
rescue LoadError => e
  raise "One more more dependencies have not been installed please install the gem referred to in this error #{e.message}"
end

module Bpluser
  class Engine < ::Rails::Engine
    isolate_namespace Bpluser

    # as of sprockets >= 4 have to explicitly declare each file
    initializer 'bpluser.assets.precompile' do |app|
      asset_base_path = File.join(Bpluser.root, 'app', 'assets')
      Dir.glob(File.join(asset_base_path, 'config', 'bpluser_manifest', '*')).each do |asset|
        app.config.assets.precompile << "bpluser/#{asset.split('/').last}"
      end
    end
  end
end
