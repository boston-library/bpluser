module Bpluser
  class UserInstitution < ApplicationRecord
    self.table_name = "user_institutions"
    belongs_to :user, inverse_of: :user_institutions
  end
end
