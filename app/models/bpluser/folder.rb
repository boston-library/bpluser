module Bpluser
  class Folder < ActiveRecord::Base

    belongs_to :user
    has_many :folder_items, :dependent => :destroy, :class_name => "Bpluser::FolderItem"

    validates :user_id, :presence => true
    validates :title, :presence => true, :length => {:maximum => 40}
    validates :description, :length => {:maximum => 250}
    validates :visibility, :inclusion  => {:in => %w(public private)}

    attr_accessible :id, :title, :description, :visibility
  end
end