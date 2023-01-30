# frozen_string_literal: true

# use to share folder item actions (email, cite, delete) between folders and bookmarks
class FolderItemsActionsController < ApplicationController
  def folder_item_actions
    @folder = Bpluser::Folder.find(params[:id]) if params[:origin] == 'folders'
    @user = current_or_guest_user

    unless params[:selected]
      flash[:error] = I18n.t('blacklight.folders.update_items.remove.no_items')
      redirect_back(fallback_location: root_path)
    end

    items = params[:selected]
    case params[:commit]
    # email
    when t('blacklight.tools.email')
      redirect_to email_solr_document_path(id: items)
    # cite
    when t('blacklight.tools.citation')
      redirect_to citation_solr_document_path(id: items)
    # remove
    when t('blacklight.tools.remove')
      if params[:origin] == 'folders'
        if @folder.folder_items.destroy_by(document_id: items)
          flash[:notice] = t('blacklight.folders.update_items.remove.success')
        else
          flash[:error] = t('blacklight.folders.update_items.remove.failure')
        end
        redirect_to folder_path(@folder, view_params)
      else
        if current_or_guest_user.bookmarks.destroy_by(document_id: items)
          flash[:notice] = t('blacklight.folders.update_items.remove.success')
        else
          flash[:error] = t('blacklight.folders.update_items.remove.failure')
        end
        redirect_to bookmarks_path(view_params)
      end
    # copy
    when /#{t('blacklight.tools.copy_to')}/
      destination = params[:commit].split(t('blacklight.tools.copy_to') + ' ')[1]
      if destination == t('blacklight.bookmarks.title')
        success = items.all? do |item_id|
          next true if current_or_guest_user.bookmarks.exists?(document_id: item_id)

          current_or_guest_user.bookmarks.create(document_id: item_id)
        end
      else
        folder_to_update = current_user.folders.find(destination)
        success = items.all? do |item_id|
          next true if folder_to_update.folder_item?(item_id)

          begin
            folder_to_update.folder_items.create!(document_id: item_id)
            next true
          rescue ActiveRecord::RecordInvalid
            break false
          end
        end
      end

      if success
        folder_display_name = destination == t('blacklight.bookmarks.title') ? t('blacklight.bookmarks.title') : folder_to_update.title
        flash[:notice] = t('blacklight.folders.update_items.copy.success', folder_name: folder_display_name)
      else
        flash[:error] = t('blacklight.folders.update_items.copy.failure')
      end
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def view_params
    params.permit(:sort, :per_page, :view)
  end
end
