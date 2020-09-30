module Bpluser
  module Sessions
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

      def resource_params
        params.require(:user).permit(:username, :email, :first_name, :last_name, :provider, :display_name, :password, :password_confirmation, :uid)
      end
    end
  end
end
