# frozen_string_literal: true

class AddForeignKeysAndIndexesToFolderAndFolderItems < ActiveRecord::Migration[6.0]
  def change
    add_index :bpluser_folders, :user_id
    add_foreign_key :bpluser_folders, :users
    add_foreign_key :bpluser_folder_items, :bpluser_folders, column: :folder_id
  end
end
