class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Connects this user object to the BPL omniauth service
  include Bpluser::Concerns::User
  self.table_name = "users"

end
