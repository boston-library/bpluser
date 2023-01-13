# frozen_string_literal: true

module Bpluser
  module Users
    # Changed this to a concern so the modules can resolve better
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
      include Validatable

      devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:polaris]

      has_many :folders, inverse_of: :user, dependent: :destroy, class_name: 'Bpluser::Folder'
      has_many :folder_items, through: :folders, class_name: 'Bpluser::FolderItem'
    end

    module InstanceMethods
      # BEGIN INSTANCE METHODS
      def to_s
        self.name
      end

      def name
        self.username rescue self.display_name&.titleize
      end

      def user_key
        send(Devise.authentication_keys.first)
      end

      def existing_folder_item_for(document_id)
        self.get_folder_item(document_id)
      end

      def get_folder_item (document_id)
        folder_items.where(document_id: document_id).first if self.folder_items.where(document_id: document_id).exists?
      end

      def permanent_account?
        self.provider != 'digital_stacks_temporary'
      end

      def email_not_required?
        self.provider != 'polaris'
      end
      #END INSTANCE METHODS
    end

    # BEGIN CLASS METHODS
    class_methods do
      def find_for_polaris_oauth(auth_response, signed_in_resource = nil)
        polaris_raw_details = auth_response[:extra][:raw_info]
        polaris_info_details = auth_response[:info]

        user = User.where(provider: auth_response.provider, uid: auth_response[:uid]).first

        #first_name:ldap_info_details.first_name,
        #last_name:ldap_info_details.last_name,
        unless user
          email_value = polaris_info_details[:email].present? ? polaris_info_details[:email] : ''
          #For some reason, User.create has no id set despite that intending to be autocreated. Unsure what is up with that. So trying this.
          user = User.new(provider:auth_response.provider,
                             uid:auth_response[:uid],
                             username:polaris_info_details[:first_name],
                             email:email_value,
                             password:Devise.friendly_token[0,20],
                             display_name:polaris_info_details[:first_name] + " " + polaris_info_details[:last_name],
                             first_name: polaris_info_details[:first_name],
                             last_name: polaris_info_details[:last_name]

          )
          user.save!

        end
        user
      end

      def find_for_local_auth(auth, signed_in_resource=nil)
        user = User.where(:provider => auth.provider, :uid => auth.uid).first
        unless user
          user = User.create(display_name:auth.full_name,
                             uid:auth.uid,
                             provider:auth.provider,
                             username:auth.uid,
                             email:auth.email,
                             password:auth.password,
                             first_name:auth.first_name,
                             last_name:auth.last_name
          )
        end
        user
      end
    end
    # END CLASS METHODS
  end
end
