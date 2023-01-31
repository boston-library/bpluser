# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # https://github.com/plataformatec/devise/issues/2432
    # The above issue no longer applies
    # this is the only spot where we allow CSRF, our openid / oauth redirect
    # will not have a CSRF token, however the payload is all validated so its safe
    # skip_before_action :verify_authenticity_token
    # UPDATE: since we can now use omniauth-rails_csrf_protection we can now use csrf tokens when registering omniauth users

    include Bpluser::OmniauthCallbacks
  end
end
