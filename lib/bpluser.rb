require 'bpluser/engine'
require 'bpluser/version'

module Bpluser
  require 'bpluser/controller'
  #autoload :Routes, 'bpluser/routes'

  #def self.add_routes(router, options = {})
  #  Bpluser::Routes.new(router, options).draw
  #end

  def self.root
    @root ||= File.expand_path(File.dirname(File.dirname(__FILE__)))
  end
end
