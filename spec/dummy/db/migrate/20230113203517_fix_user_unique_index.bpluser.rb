# frozen_string_literal: true

# This migration comes from bpluser (originally 20150527000001)

class FixUserUniqueIndex < ActiveRecord::Migration[4.2]
  def change
    remove_index :users, :email

    add_index :users, [:provider, :uid], :unique => true
    add_index :users, :email
  end
end
