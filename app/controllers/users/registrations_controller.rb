# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include Bpluser::Registrations
end
