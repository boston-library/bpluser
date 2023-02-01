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
        case params['action']
        when 'create'
          devise_parameter_sanitizer.permit(:sign_up) do |u|
            u.permit(:username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name)
              .with_defaults(username: params.dig(:user, :email), display_name: default_display_name)
          end
        when 'update'
          devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name, :current_password) }
        end
      end

      # POST /resource
      def create
        if User.exists?(email: sign_up_params[:email])
          flash[:error] = "An account with that email (#{resource_params[:email]}) already exists. Please sign in or click the \"Forgot your password?\" link below."
          redirect_to new_user_session_path
        end

        super
      end

      def resource_params
        params
          .require(:user)
          .permit(:username, :email, :first_name, :last_name, :display_name, :password, :password_confirmation)
          .with_defaults
      end

      def default_display_name
        return if %i[first_name last_name].all? { |name_part| params.dig(:user, name_part).blank? }

        "#{params.dig(:user, :first_name)} #{params.dig(:user, :last_name)}".strip
      end
    end
  end
end
