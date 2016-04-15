module Bpluser::Users::OmniauthCallbacksController


  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods


    def ldap

      @user = User.find_for_ldap_oauth(request.env["omniauth.auth"], current_user)

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Ldap"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.ldap_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

    def polaris
      @user = User.find_for_polaris_oauth(request.env["omniauth.auth"], current_user)
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Polaris"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.polaris_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

    def password
      puts "here in local authentication!"
    end

    def facebook
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end
end