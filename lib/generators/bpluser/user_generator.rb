require 'rails/generators'

module Bpluser
  class UserGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc "UserGenerator Bpluser"

    def omniauth
      return if IO.read("app/models/user.rb").include?('Bpluser')

      insert_into_file "app/models/user.rb", after: 'include Blacklight::User' do
        "\n\n  # Connects this user object to the BPL omniauth service" \
        "\n  include Bpluser::Concerns::Users" \
        "\n  self.table_name = 'users'\n"
      end
    end

    def add_trackable_to_devise
      return if IO.read("app/models/user.rb").include?('trackable')

      insert_into_file 'app/models/user.rb', after: 'devise :' do
        'trackable, :'
      end
    end
  end
end
