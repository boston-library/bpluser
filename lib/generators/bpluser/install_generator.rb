# frozen_string_literal: true

require 'rails/generators'

module Bpluser
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'InstallGenerator Bpluser'

    def verify_blacklight_installed
      return if File.read('app/controllers/application_controller.rb').include?('include Blacklight::Controller')

      say_status('info', 'BLACKLIGHT NOT INSTALLED; GENERATING BLACKLIGHT', :blue)
      generate 'blacklight:install --devise'
    end

    def verify_devise_installed
      user_model = 'app/models/user.rb'
      return if !File.file?(user_model) || File.read(user_model).include?('devise')

      generate 'blacklight:user --devise'
    end

    def copy_yml_files
      %w[omniauth-polaris].each do |yml|
        source_dest = "config/#{yml}.yml"
        copy_file source_dest, source_dest unless File.file?(source_dest)
      end
    end

    def copy_locale
      copy_file 'config/locales/devise.en.yml', 'config/locales/devise.en.yml'
    end

    def insert_to_user_model
      generate 'bpluser:user'
    end

    def copy_migrations
      rake 'bpluser:install:migrations'
    end

    def copy_update_migrations
      rake 'bpluser:update:migrations'
    end

    def configure_devise
      generate 'bpluser:devise'
    end

    def insert_to_controllers
      generate 'bpluser:controller'
    end

    def add_initializers
      template 'config/initializers/recaptcha.rb'
    end

    def bundle_install
      Bundler.with_clean_env do
        run 'bundle install'
      end
    end
  end
end
