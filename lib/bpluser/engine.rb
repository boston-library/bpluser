begin
  require 'base64'
  require 'cgi'
  require 'openssl'
  require 'rest_client'
  require 'active_support/concern' unless defined? ActiveSupport::Concern
  require 'hydra-ldap' unless defined? Hydra::LDAP
  require 'devise'
  require 'devise-guests'
  require 'omniauth'
  require 'omniauth-ldap'
  require 'omniauth-facebook'
  require 'omniauth-polaris'
rescue LoadError => e
  raise "One more more dependencies have not been installed please install the gem referred to in this error #{e.message}"
end

module Bpluser
  class Engine < ::Rails::Engine
    isolate_namespace Bpluser
  end
end
