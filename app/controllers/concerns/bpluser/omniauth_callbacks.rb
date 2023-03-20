# frozen_string_literal: true

module Bpluser
  module OmniauthCallbacks
    extend ActiveSupport::Concern

    included do
      include InstanceMethods

      skip_before_action :verify_authenticity_token, only: [:polaris, :failure]
    end

    module InstanceMethods
      def polaris
        @user = User.find_for_polaris_oauth(request.env['omniauth.auth'])

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: 'Polaris') if is_navigational_format?
        else
          session['devise.polaris_data'] = request.env['omniauth.auth'].except(:extra)
          redirect_to new_user_registration_url
        end
      end
    end
  end
end
