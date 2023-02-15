# frozen_string_literal: true

class AddVisibilityToBpluserFolders < ActiveRecord::Migration[4.2]
  def change
    add_column :bpluser_folders, :visibility, :string
  end
end
