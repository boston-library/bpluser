# frozen_string_literal: true

# Filters added to this controller apply to all controllers in local app
# this module is mixed-in to local app's ApplicationController on installation.
module Bpluser
  module Controller
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
      after_action :store_location
    end

    module InstanceMethods
      EXCLUDE_PATHS = %w[
        /users/auth
        /users/sign_in
        /users/sign_up
        /users/password
        /users/password/new
        /users/password/edit
        /users/confirmation
        /users/sign_out
      ].freeze
      # redirect after login to previous non-login page
      # TODO figure out why it doesn't work for Polaris
      def store_location
        # Don't store if ajax call or fullpath doesn't include segments in EXCLUDE_PATHS const
        return if request.xhr? || EXCLUDE_PATHS.any? { |exclude_path| request.fullpath.include?(exclude_path) }

        session[:previous_url] = request.fullpath
      end

      def after_sign_in_path_for(_resource)
        session[:previous_url] || root_path
      end

      private

      ##
      # adds behavior to Blacklight::Controller#transfer_guest_user_actions_to_current_user
      # so folders are transferred in addition to searches and bookmarks
      def transfer_guest_user_actions_to_current_user
        return unless respond_to?(:current_user) && respond_to?(:guest_user) && current_user && guest_user

        guest_user.folders.with_folder_items.find_each do |folder|
          target_folder = current_user.folders.where(title: folder.title).first

          if target_folder.blank?
            target_folder = current_user.folders.create!(title: folder.title, description: folder.description, visibility: folder.visibility)
          end

          folder.folder_items.find_each do |item_to_add|
            next if target_folder.folder_item?(item_to_add.document_id)

            target_folder.folder_items.create!(document_id: item_to_add.document_id)
          end
        end

        super
      end
    end
  end
end
