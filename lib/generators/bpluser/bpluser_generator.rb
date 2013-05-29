require 'rails/generators'
require 'rails/generators/migration'


class BpluserGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  argument :model_name, :type => :string , :default => "user"
  class_option :devise , :type => :boolean, :default => false, :aliases => "-d", :desc => "Use Devise as authentication logic (this is default)."
  class_option :role_management , :type => :boolean, :default => false, :aliases => "-r", :desc => "Use Hydra Role Management as authentication logic (this is default)."


  desc """
This generator makes the following changes to your application:
1. List here

Thank you for Installing BPLUser.
"""

  # Implement the required interface for Rails::Generators::Migration.
  # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
  def self.next_migration_number(path)
    unless @prev_migration_nr
      @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
    else
      @prev_migration_nr += 1
    end
    @prev_migration_nr.to_s
  end

  def check_arguments
    #if File.exists?("app/models/#{model_name}.rb") and options[:devise]
      #puts "Because you have selected \"#{model_name}\", which is an existing class, you will need to install devise manually and then run this generator without the Devise option. You can find additional information here: https://github.com/plataformatec/devise. \n Please be sure to include a to_s method in #{model_name} that returns the users name or email, as this will be used by Blacklight to provide a link to user specific information."
      #exit
    #end
  end

  # Install Devise?
  def generate_devise_assets
    if options[:devise]
      if Rails::VERSION::MAJOR == 4
        gem "devise", github:'plataformatec/devise', branch: 'rails4'
      else
        gem "devise"
      end

      gem "devise-guests", "~> 0.3"

      Bundler.with_clean_env do
        run "bundle install"
      end

      generate "devise:install"
      generate "devise", model_name.classify
      generate "devise_guests", model_name.classify
      generate "devise:views"

    end
  end


  #Add gem dependenceies
  def add_the_gems
    gem 'omniauth'
    gem 'omniauth-ldap'
    gem 'omniauth-facebook'
    gem 'omniauth-polaris', :git => 'https://github.com/boston-library/omniauth-polaris.git'
    gem 'omniauth-password'
    Bundler.with_clean_env do
      run "bundle install"
    end
  end


  # Copy all files in templates/config directory to host config
  def create_configuration_files
    copy_file "config/initializers/devise.rb", "config/initializers/devise.rb"
    copy_file "controllers/users/omniauth_callbacks_controller.rb", "app/controllers/users/omniauth_callbacks_controller.rb"
    copy_file "models/user.rb", "app/models/user.rb"
    copy_file "models/ability.rb", "app/models/ability.rb"

    if !File.exists?("config/hydra-ldap.yml")
      copy_file "config/hydra-ldap.yml", "config/hydra-ldap.yml"
    end

    if !File.exists?("config/omniauth-polaris.yml")
      copy_file "config/omniauth-polaris.yml", "config/omniauth-polaris.yml"
    end

    if !File.exists?("config/omniauth-facebook.yml")
      copy_file "config/omniauth-facebook.yml", "config/omniauth-facebook.yml"
    end

  end

  # Setup the database migrations
  def copy_migrations
    # Can't get this any more DRY, because we need this order.
    better_migration_template "add_fields_to_user.rb"
    better_migration_template "add_folders_to_user.rb"
    better_migration_template "add_folder_items_to_folder.rb"
    better_migration_template "create_institutions_for_users.rb"
    better_migration_template "add_uid_to_user.rb"
  end


  # Install Hydra Role Management?
  def generate_hydra_role_management
    if options[:role_management]
      if Rails::VERSION::MAJOR == 4
        #gem "devise", github:'plataformatec/devise', branch: 'rails4'
      else
        gem "hydra-role-management"
      end
      generate "roles"
      Bundler.with_clean_env do
        run "bundle install"
      end
    end
  end

  def inject_bpluser_routes
    # These will end up in routes.rb file in reverse order
    # we add em, since each is added at the top of file.
    # we want "root" to be FIRST for optimal url generation.
    #route('devise_for :users, :controllers => { :omniauth_callbacks => "bpluser/users/omniauth_callbacks" }')
    gsub_file("config/routes.rb", "devise_for :users", "")
    route('devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }')
    route('mount Bpluser::Engine => "/bpluser"')
    route('Bpluser.add_routes(self)')
  end


  private

  def better_migration_template (file)
    begin
      migration_template "migrations/#{file}", "db/migrate/#{file}"
      sleep 1 # ensure scripts have different time stamps
    rescue
      puts " \e[1m\e[34mMigrations\e[0m " + $!.message
    end
  end




end