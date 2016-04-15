require "bpluser/engine"

module Bpluser
  autoload :Routes, 'bpluser/routes'

  def self.add_routes(router, options = {})
    Bpluser::Routes.new(router, options).draw
  end
end
