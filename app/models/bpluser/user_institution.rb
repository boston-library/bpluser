module Bpluser
  class UserInstitution < ActiveRecord::Base
    self.table_name = "user_institutions"
    belongs_to :user
  end
end