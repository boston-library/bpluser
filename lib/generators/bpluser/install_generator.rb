# frozen_string_literal: true

require 'rails/generators'

module Bpluser
  class InstallGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc 'InstallGenerator Bpluser'

    def verify_blacklight_installed
      return if IO.read('app/controllers/application_controller.rb').include?('include Blacklight::Controller')

      say_status('info', 'BLACKLIGHT NOT INSTALLED; GENERATING BLACKLIGHT', :blue)
      generate "blacklight:install --devise"
    end

    def verify_devise_installed
      user_model = 'app/models/user.rb'
      return if !File.exist?(user_model) || IO.read(user_model).include?('devise')

      generate 'blacklight:user --devise'
    end

    def copy_yml_files
      %w(omniauth-polaris).each do |yml|
        source_dest = "config/#{yml}.yml"
        copy_file source_dest, source_dest unless File.exist?(source_dest)
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

    def configure_devise
      generate 'bpluser:devise'
    end

    def insert_to_controllers
      generate 'bpluser:controller'
    end

    def inject_user_routes
      gsub_file("config/routes.rb", 'devise_for :users',
                "devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations', sessions: 'users/sessions' }")
    end

    def bundle_install
      Bundler.with_clean_env do
        run 'bundle install'
      end
    end
  end
end
