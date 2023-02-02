# frozen_string_literal: true

module Bpluser
  module Registrations
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
      before_action :configure_permitted_parameters, if: :devise_controller?
    end

    module InstanceMethods
      # POST /resource
      def create
        if User.exists?(email: sign_up_params[:email])
          flash[:error] = "An account with that email (#{resource_params[:email]}) already exists. Please sign in or click the \"Forgot your password?\" link below."
          redirect_to new_user_session_path
        end

        super
      end

      protected

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name])
        devise_parameter_sanitizer.permit(:account_update, keys: %i[username email password password_confirmation remember_me first_name last_name display_name current_password])
      end
    end
  end
end
