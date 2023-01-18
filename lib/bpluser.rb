require 'blacklight'
require 'base64'
require 'cgi'
require 'openssl'
require 'active_support'
require 'active_support/concern'
require 'devise'
require 'devise-guests'
require 'omniauth'
require 'omniauth-polaris'
require 'omniauth/rails_csrf_protection'

require 'bpluser/version'
require 'bpluser/controller'
require 'bpluser/engine'

module Bpluser
  def self.root
    File.expand_path(__dir__)
  end
end
