# -*- encoding : utf-8 -*-
class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    add_column :users, :provider, :string
    add_column :users, :display_name, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :uid, :string

  end

  def self.down
    remove_column :users, :username
    remove_column :users, :provider
    remove_column :users, :display_name
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :uid
  end
end
