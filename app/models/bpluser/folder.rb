module Bpluser
  class Folder < ApplicationRecord

    belongs_to :user, inverse_of: :folders, class_name: "::User"
    has_many :folder_items, inverse_of: :folder ,:dependent => :destroy, :class_name => "Bpluser::FolderItem"

    validates :user_id, :presence => true
    #validates :title, :presence => true, :length => {:maximum => 40}
    validates :title, :presence => true, :length => {:maximum => 65}
    validates :description, :length => {:maximum => 250}
    validates :visibility, :inclusion  => {:in => %w(public private)}

    #attr_accessible :id, :title, :description, :visibility

    def has_folder_item (document_id)
      self.folder_items.where(document_id: document_id) if self.folder_items.where(document_id: document_id).exists?
    end

  end
end
