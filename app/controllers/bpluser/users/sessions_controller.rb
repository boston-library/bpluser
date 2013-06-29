module Bpluser::Users::SessionsController
#< Devise::RegistrationsController
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    # GET /resource/sign_in
    def new
      if params[:user]
        #TODO: FIX THIS
        params[:user][:provider] = "local"
      end

      super
    end

  end
end