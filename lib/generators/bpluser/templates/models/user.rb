# frozen_string_literal: true

class User < ApplicationRecord
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Connects this user object to the BPL omniauth service
  include Bpluser::Concerns::User
  self.table_name = "users"
end
