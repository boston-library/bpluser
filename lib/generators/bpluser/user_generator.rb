# frozen_string_literal: true

require 'rails/generators'

module Bpluser
  class UserGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'UserGenerator Bpluser'

    argument :user_model_path, type: :string, default: 'app/models/user.rb'

    def omniauth
      return if File.read(user_model_path).include?('Bpluser')

      insert_into_file user_model_path, after: 'include Blacklight::User' do
        "\n\n  # Connects this user object to the BPL omniauth service" \
          "\n  include Bpluser::Users" \
          "\n  self.table_name = 'users'\n"
      end
    end

    def add_trackable_to_devise
      # check for :trackable, but only if not in comments
      return if File.read(user_model_path).match?(/^[\s]+[:a-z,\s]*trackable/)

      insert_into_file 'app/models/user.rb', after: 'devise :' do
        'trackable, :'
      end
    end
  end
end
