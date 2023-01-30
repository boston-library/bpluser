# frozen_string_literal: true

module Bpluser
  module Registrations
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
      before_action :update_sanitized_params, if: :devise_controller?
    end

    module InstanceMethods
      def update_sanitized_params
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:provider, :username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name, :uid) }
        devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:provider, :username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name, :uid, :current_password) }
      end

      # POST /resource
      def create
        if User.exists?(provider: resource_params[:provider], uid: resource_params[:email])
          flash[:error] = "An account with that email (#{resource_params[:email]}) already exists. Please sign in or click the \"Forgot your password?\" link below."
          redirect_to new_user_session_path
        end
        super
      end

      def resource_params
        params
          .require(:user)
          .permit(:username, :email, :first_name, :last_name, :provider, :display_name, :password, :password_confirmation, :uid)
          .with_defaults(provider: 'local', uid: params.dig(:user, :email), username: params.dig(:user, :email), display_name: default_display_name)
      end

      def default_display_name
        return if %i[first_name last_name].all? { |name_part| params.dig(:user, name_part).blank? }

        "#{params.dig(:user, :first_name)} #{params.dig(:user, :last_name)}".strip
      end
    end
  end
end
