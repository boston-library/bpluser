# frozen_string_literal: true

# Filters added to this controller apply to all controllers in local app
# this module is mixed-in to local app's ApplicationController on installation.
module Bpluser
  module Controller

    extend ActiveSupport::Concern

    included do
      after_action :store_location
    end

    # redirect after login to previous non-login page
    # TODO figure out why it doesn't work for Polaris or Facebook logins
    def store_location
      if request.path != "/users/sign_in" &&
         request.path != "/users/sign_up" &&
         request.path != "/users/password" &&
         request.path != "/users/password/new" &&
         request.path != "/users/password/edit" &&
         request.path != "/users/confirmation" &&
         request.path != "/users/sign_out" &&
         !request.fullpath.match(/\/users\/auth\//) &&
         !request.xhr? # don't store ajax calls
        session[:previous_url] = request.fullpath
      end
    end

    def after_sign_in_path_for(resource)
      session[:previous_url] || root_path
    end

    private

    ##
    # adds behavior to Blacklight::Controller#transfer_guest_user_actions_to_current_user
    # so folders are transferred in addition to searches and bookmarks
    def transfer_guest_user_actions_to_current_user
      return unless respond_to? :current_user and respond_to? :guest_user and current_user and guest_user

      guest_user.folders.find_each do |folder|
        target_folder = current_user.folders.where(title: folder.title)
        if target_folder.blank?
          target_folder = current_user.folders.create(title: folder.title, description: folder.description, visibility: folder.visibility)
          target_folder.save!
        else
          target_folder = target_folder.first
        end
        folder.folder_items.find_each do |item_to_add|
          unless target_folder.has_folder_item(item_to_add.document_id)
            target_folder.folder_items.create(:document_id => item_to_add.document_id) and target_folder.touch
            target_folder.save!
          end
        end
      end

      super
    end
  end
end
