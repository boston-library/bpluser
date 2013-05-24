# -*- encoding : utf-8 -*-
class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    add_column :users, :provider, :string

  end

  def self.down
    remove_column :users, :username
    remove_column :users, :username
  end
end
