class Users::RegistrationsController < Devise::RegistrationsController
  include Bpluser::Registrations
end
