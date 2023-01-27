# frozen_string_literal: true

module Bpluser
  module OmniauthCallbacks
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
    end

    module InstanceMethods
      def polaris
        @user = User.find_for_polaris_oauth(request.env['omniauth.auth'], current_user)

        if @user.persisted?
          flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: "Polaris"
          sign_in_and_redirect @user, event: :authentication
        else
          session['devise.polaris_data'] = request.env['omniauth.auth']
          redirect_to new_user_registration_url
        end
      end
    end
  end
end
