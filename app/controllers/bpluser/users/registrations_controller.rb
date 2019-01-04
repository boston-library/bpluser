module Bpluser::Users::RegistrationsController
#TODO Make this an actual controller
#< Devise::RegistrationsController
  def self.included(base)
    base.send :include, Devise::Controllers::Helpers
    base.send :before_action, :update_sanitized_params, :if => :devise_controller?
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def update_sanitized_params
      devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:provider, :username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name, :uid)}
      devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:provider, :username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name, :uid, :current_password)}
    end

    # POST /resource
    def create
      #devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :first_name, :last_name, :provider, :display_name, :password, :password_confirmation, :uid) }
      params[:user][:provider] = "local"
      params[:user][:uid] = params[:user][:email]
      params[:user][:username] = params[:user][:uid]
      params[:user][:display_name] = params[:user][:first_name] + " " + params[:user][:last_name]
      if User.where(:provider => params[:user][:provider], :uid => params[:user][:email]).exists?
        flash[:error] = "An account with that email (#{params[:user][:email]}) already exists. Please sign in or click the \"Forgot your password?\" link below."
        redirect_to new_user_session_path
      else
        super
      end
    end


    def resource_params
      params.require(:user).permit(:username, :email, :first_name, :last_name, :provider, :display_name, :password, :password_confirmation, :uid)
    end
  end
end
