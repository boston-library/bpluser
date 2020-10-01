begin
  require 'base64'
  require 'cgi'
  require 'openssl'
  require 'rest_client'
  require 'active_support/concern' unless defined? ActiveSupport::Concern
  require 'hydra-ldap' unless defined? Hydra::LDAP
rescue LoadError => e
  raise "One more more dependencies have not been installed please install the gem referred to in this error #{e.message}"
end
require 'bpluser/engine'

module Bpluser
  autoload :Routes, 'bpluser/routes'

  def self.add_routes(router, options = {})
    Bpluser::Routes.new(router, options).draw
  end

  def self.root
    @root ||= File.expand_path(File.dirname(File.dirname(__FILE__)))
  end
end
