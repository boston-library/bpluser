# frozen_string_literal: true

# This migration comes from bpluser (originally 20130628143428)

class AddFolderItemsToFolder < ActiveRecord::Migration[4.2]
  def self.up
    create_table :bpluser_folder_items do |t|
      t.integer :folder_id
      t.string :document_id

      t.timestamps
    end

    add_index :bpluser_folder_items, :folder_id
    add_index :bpluser_folder_items, :document_id
  end

  def self.down
    drop_table :bpluser_folder_items
  end
end
