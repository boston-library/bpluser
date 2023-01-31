# frozen_string_literal: true

require 'base64'
require 'cgi'
require 'active_support'
require 'active_support/concern'
require 'blacklight'
require 'devise'
require 'devise-guests'
require 'omniauth'
require 'omniauth-polaris'
require 'omniauth/rails_csrf_protection'
require 'openssl'
require 'rsolr'

require 'bpluser/version'
require 'bpluser/controller'
require 'bpluser/devise_guests_override'
require 'bpluser/engine'

module Bpluser
  def self.root
    Bpluser::Engine.root
  end
end
