begin
  require 'active_support/concern' unless defined? ActiveSupport::Concern
  require 'active_fedora' unless defined? ActiveFedora::SolrService
  require 'hydra-ldap' unless defined? Hydra::LDAP
  require 'devise' unless defined? Devise::Models
rescue LoadError => e
  raise "One more more depndencies have not been installed please install the gem referred to in this error #{e.message}"
end

module Bpluser
  module Models
    autoload :Validatable, 'bpluser/models/validatable'
    autoload :Users, 'bpluser/models/users'
    Users.send(:include, Validatable)
  end
end
