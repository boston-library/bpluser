# frozen_string_literal: true
# This migration comes from bpluser (originally 20140124193815)

class AddVisibilityToBpluserFolders < ActiveRecord::Migration[4.2]
  def change
    add_column :bpluser_folders, :visibility, :string
  end
end
