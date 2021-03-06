module Bpluser
  class FolderItem < ApplicationRecord
    #attr_accessible :document_id

    belongs_to :folder, inverse_of: :folder_items, :class_name => "Bpluser::Folder"

    validates :folder_id, :presence => true
    validates :document_id, :presence => true

    def document
      SolrDocument.new SolrDocument.unique_key => :document_id
    end

  end
end
