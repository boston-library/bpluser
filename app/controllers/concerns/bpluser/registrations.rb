# frozen_string_literal: true

module Bpluser
  module Registrations
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
      before_action :configure_permitted_parameters, only: [:create, :update], if: :devise_controller?
    end

    module InstanceMethods
      # override #create from Devise::RegistrationsController to add verify_captcha and logic for error handling
      # this is the best way to preserve and re-render any submitted params when verify_recaptcha fails
      def create
        build_resource(sign_up_params)

        resource.save if verify_recaptcha

        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          resource.errors.add(:errors, message: t('devise.registrations.recaptcha_error')) unless verify_recaptcha
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
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
