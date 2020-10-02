require 'rails/generators'

module Bpluser
  class InstallGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc "InstallGenerator Bpluser"

    def verify_blacklight_installed
      return if IO.read('app/controllers/application_controller.rb').include?('include Blacklight::Controller')

      say_status('info', 'BLACKLIGHT NOT INSTALLED; GENERATING BLACKLIGHT', :blue)
      generate "blacklight:install --devise"
    end

    def verify_devise_installed
      return if IO.read('app/models/user.rb')&.include?('devise')

      generate 'blacklight:user --devise'
    end

    def copy_yml_files
      copy_file 'config/omniauth-facebook.yml' unless File::exists?('config/omniauth-facebook.yml')
      copy_file 'config/omniauth-polaris.yml' unless File::exists?('config/omniauth-polaris.yml')
      copy_file 'config/hydra-ldap.yml' unless File::exists?('config/hydra-ldap.yml')
    end

    def insert_to_user_model
      generate 'bpluser:user'
    end

    def copy_migrations
      rake 'railties:install:migrations'
    end

    def configure_devise
      generate 'bpluser:devise'
    end

    def insert_to_controllers
      generate 'bpluser:controller', controller_name
    end

    def bundle_install
      Bundler.with_clean_env do
        run 'bundle install'
      end
    end
  end
end
