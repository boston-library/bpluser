# frozen_string_literal: true

require 'rails/generators'

module Bpluser
  class DeviseGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'DeviseGenerator Bpluser'

    argument :devise_initializer, type: :string, default: 'config/initializers/devise.rb'

    def keys
      gsub_file(devise_initializer, /^[\s#]*config.authentication_keys[^\n]*/,
                '  config.authentication_keys = [:email]')
      gsub_file(devise_initializer, /^[\s#]*config.case_insensitive_keys[^\n]*/,
                '  config.case_insensitive_keys = [:email]')
      gsub_file(devise_initializer, /^[\s#]*config.strip_whitespace_keys[^\n]*/,
                '  config.strip_whitespace_keys = [:email]')
    end

    def sign_out
      gsub_file(devise_initializer, /^[\s#]*config.sign_out_via[^\n]*/,
                '  config.sign_out_via = :get')
    end

    def omniauth
      return if File.read(devise_initializer).include?('config.omniauth')

      marker = '# ==> Warden configuration'
      insert_into_file devise_initializer, before: marker do
        "config.omniauth :polaris, title: OMNIAUTH_POLARIS_GLOBAL['title']," \
          "\n                  http_uri: OMNIAUTH_POLARIS_GLOBAL['http_uri']," \
          "\n                  access_key: OMNIAUTH_POLARIS_GLOBAL['access_key']," \
          "\n                  access_id: OMNIAUTH_POLARIS_GLOBAL['access_id']," \
          "\n                  method: OMNIAUTH_POLARIS_GLOBAL['method']\n\n"
      end
    end
  end
end
