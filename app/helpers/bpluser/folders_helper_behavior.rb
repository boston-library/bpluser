# frozen_string_literal: true

module Bpluser
  module FoldersHelperBehavior
    def folder_belongs_to_user(folder)
      return false if folder.blank?

      current_or_guest_user.folders.include?(folder)
    end
  end
end
