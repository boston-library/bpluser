# frozen_string_literal: true

module Bpluser
  class FolderItem < ApplicationRecord
    belongs_to :folder, inverse_of: :folder_items, class_name: 'Bpluser::Folder', touch: true

    validates :document_id, presence: true

    def document
      SolrDocument.new(SolrDocument.unique_key => document_id) if document_id
    end
  end
end
