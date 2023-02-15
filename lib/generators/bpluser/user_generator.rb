# frozen_string_literal: true

require 'rails/generators'

module Bpluser
  class UserGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'UserGenerator Bpluser'

    argument :user_model_path, type: :string, default: 'app/models/user.rb'

    def insert_into_users
      return if File.read(user_model_path).include?('Bpluser')

      insert_into_file user_model_path, after: 'include Blacklight::User' do
        "\n\n  # Adds Bpluser core funtionality" \
          "\n  include Bpluser::Users" \
          "\n  self.table_name = 'users'\n"
      end
    end
  end
end
