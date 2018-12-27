module Bpluser
  class Folder < ActiveRecord::Base

    belongs_to :user
    has_many :folder_items, :dependent => :destroy, :class_name => "Bpluser::FolderItem"

    validates :user_id, :presence => true
    #validates :title, :presence => true, :length => {:maximum => 40}
    validates :title, :presence => true, :length => {:maximum => 65}
    validates :description, :length => {:maximum => 250}
    validates :visibility, :inclusion  => {:in => %w(public private)}

    #attr_accessible :id, :title, :description, :visibility

    def has_folder_item (document_id)
      self.folder_items.find do |fldr_itm|
        return fldr_itm if fldr_itm.document_id == document_id
      end
    end

  end
end
