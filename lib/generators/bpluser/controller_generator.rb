require 'rails/generators'

module Bpluser
  class ControllerGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def inject_application_controller_behavior
      target_file = 'app/controllers/application_controller.rb'
      unless IO.read(target_file).include?('Bpluser::Controller')
        marker = 'include Blacklight::Controller'
        insert_into_file target_file, after: marker do
          "\ninclude Bpluser::Controller"
        end
      end
    end
  end
end
