require "bpluser/engine"
require "bpluser/validatable"

module Bpluser
  autoload :Routes, 'bpluser/routes'

  def self.add_routes(router, options = {})
    Bpluser::Routes.new(router, options).draw
  end
end
