class Users::SessionsController < Devise::SessionsController
  include Bpluser::Sessions
end
