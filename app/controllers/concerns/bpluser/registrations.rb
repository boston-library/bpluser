# frozen_string_literal: true

module Bpluser
  module Registrations
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
      before_action :configure_permitted_parameters, only: [:create, :update], if: :devise_controller?
    end

    module InstanceMethods
      # POST /resource
      def create
        if User.exists?(email: sign_up_params[:email])
          flash[:error] = "An account with that email (#{sign_up_params[:email]}) already exists. Please sign in or click the \"Forgot your password?\" link below."
          redirect_to new_user_session_path and return
        end

        super
      end

      protected

      def configure_permitted_parameters
        case params[:action]
        when 'create'
          devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
        when 'update'
          devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
        end
      end
    end
  end
end
