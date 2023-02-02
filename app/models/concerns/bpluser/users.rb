# frozen_string_literal: true

module Bpluser
  module Users
    # Changed this to a concern so the modules can resolve better
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
      include Bpluser::Validatable

      devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable, :omniauthable, omniauth_providers: [:polaris]

      has_many :folders, inverse_of: :user, dependent: :destroy, class_name: 'Bpluser::Folder'
      has_many :folder_items, through: :folders, class_name: 'Bpluser::FolderItem'

      before_create :set_default_display_name
    end

    module InstanceMethods
      # BEGIN INSTANCE METHODS
      def name
        email || username || display_name.to_s.titleize
      end

      alias to_s name

      def user_key
        send(Devise.authentication_keys.first)
      end

      def existing_folder_item_for(document_id)
        get_folder_item(document_id)
      end

      def get_folder_item(document_id)
        folder_items.where(document_id: document_id).first if folder_items.exists?(document_id: document_id)
      end

      private

      def set_default_display_name
        return if display_name.present?

        return if first_name.blank? && last_name.blank?

        self.display_name = "#{first_name} #{last_name}".strip
      end
      # END INSTANCE METHODS
    end

    # BEGIN CLASS METHODS
    class_methods do
      def find_for_polaris_oauth(auth_response)
        polaris_info_details = auth_response[:info]

        where(provider: auth_response.provider, uid: auth_response.uid).first_or_create do |user|
          user.provider = auth_response.provider
          user.uid = auth_response.uid
          user.username = polaris_info_details[:first_name]
          user.email = polaris_info_details[:email].presence || ''
          user.password = Devise.friendly_token[0, 20]
          user.display_name = "#{polaris_info_details[:first_name]} #{polaris_info_details[:last_name]}"
          user.first_name = polaris_info_details[:first_name]
          user.last_name = polaris_info_details[:last_name]
        end
      end
    end
    # END CLASS METHODS
  end
end
