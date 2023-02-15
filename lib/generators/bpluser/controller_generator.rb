# frozen_string_literal: true

require 'rails/generators'

module Bpluser
  class ControllerGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def inject_application_controller_behavior
      target_file = 'app/controllers/application_controller.rb'
      return unless File.read(target_file).include?('Bpluser::Controller')

      marker = 'include Blacklight::Controller'
      insert_into_file target_file, after: marker do
        "\ninclude Bpluser::Controller"
      end
    end

    def add_folders_show_tool
      target_file = 'app/controllers/catalog_controller.rb'
      return unless File.read(target_file).include?('folder_item_control')

      marker = 'configure_blacklight do |config|'
      insert_into_file target_file, after: marker do
        "\nconfig.add_show_tools_partial :folder_items, partial: 'folder_item_control'"
      end
    end
  end
end
