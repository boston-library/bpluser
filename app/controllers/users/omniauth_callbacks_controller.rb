# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    include Bpluser::OmniauthCallbacks
  end
end
