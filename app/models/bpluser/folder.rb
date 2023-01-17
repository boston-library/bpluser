# frozen_string_literal: true

module Bpluser
  class Folder < ApplicationRecord
    MAX_TITLE_LENGTH = 65
    MAX_DESC_LENGTH = 250
    VALID_VISIBILITY_OPTS = %w(public private).freeze

    belongs_to :user, inverse_of: :folders, class_name: '::User'
    has_many :folder_items, inverse_of: :folder, dependent: :destroy, class_name: 'Bpluser::FolderItem'

    validates :user_id, presence: true
    validates :title, presence: true, length: { maximum: MAX_TITLE_LENGTH }
    validates :description, length: { maximum: MAX_DESC_LENGTH }
    validates :visibility, inclusion: { in: VALID_VISIBILITY_OPTS }

    def has_folder_item(document_id)
      folder_items.where(document_id: document_id) if self.folder_items.where(document_id: document_id).exists?
    end
  end
end
