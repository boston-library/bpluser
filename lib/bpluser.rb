require 'base64'
require 'cgi'
require 'openssl'
require 'rest_client'
require 'bpluser/models'
require 'bpluser/engine'
module Bpluser
  autoload :Routes, 'bpluser/routes'

  def self.add_routes(router, options = {})
    Bpluser::Routes.new(router, options).draw
  end
end
