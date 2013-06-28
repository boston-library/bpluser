module Bpluser::Users::RegistrationsController
#< Devise::RegistrationsController
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    # POST /resource
    def create
      params[:user][:provider] = "local"
      params[:user][:uid] = params[:user][:email]
      params[:user][:username] = params[:user][:uid]
      params[:user][:display_name] = params[:user][:first_name] + " " + params[:user][:last_name]
      super
    end

  end
end
