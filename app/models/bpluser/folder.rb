# frozen_string_literal: true

module Bpluser
  class Folder < ApplicationRecord
    MAX_TITLE_LENGTH = 65
    MAX_DESC_LENGTH = 250
    VALID_VISIBILITY_OPTS = %w(public private).freeze

    belongs_to :user, inverse_of: :folders, class_name: '::User'
    has_many :folder_items, inverse_of: :folder, dependent: :destroy, class_name: 'Bpluser::FolderItem'

    scope :with_folder_items, -> { includes(:folder_items) }
    scope :public_list, -> { with_folder_items.where(visibility: 'public').order(updated_at: :desc) }

    validates :title, presence: true, length: { maximum: MAX_TITLE_LENGTH }
    validates :description, length: { maximum: MAX_DESC_LENGTH }
    validates :visibility, presence: true, inclusion: { in: VALID_VISIBILITY_OPTS }

    def folder_item?(document_id)
      folder_items.exists?(document_id: document_id)
    end

    def public?
      visibility == 'public'
    end

    def private?
      visibility == 'private'
    end
  end
end
