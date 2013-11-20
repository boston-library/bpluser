module Bpluser::Users::RegistrationsController
#< Devise::RegistrationsController
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    # POST /resource
    def create
      puts 'hi there Steven'
      #devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :first_name, :last_name, :provider, :display_name, :password, :password_confirmation, :uid) }
      params[:user][:provider] = "local"
      params[:user][:uid] = params[:user][:email]
      params[:user][:username] = params[:user][:uid]
      params[:user][:display_name] = params[:user][:first_name] + " " + params[:user][:last_name]
      super
    end


    def resource_params
      params.require(:user).permit(:username, :email, :first_name, :last_name, :provider, :display_name, :password, :password_confirmation, :uid)
    end

  end
end
