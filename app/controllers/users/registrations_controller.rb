# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    include Bpluser::Registrations
  end
end
