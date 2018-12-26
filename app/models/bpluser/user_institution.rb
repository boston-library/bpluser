module Bpluser
  class UserInstitution < ActiveRecord::Base
    self.table_name = "user_institutions"
    belongs_to :user, inverse_of: :user_institutions
  end
end
