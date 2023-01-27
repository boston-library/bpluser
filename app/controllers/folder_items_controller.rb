# frozen_string_literal: true

class FolderItemsController < CatalogController
  before_action :verify_user

  def update
    create
  end

  def create
    @response, @document = search_service.fetch(params[:id])

    if params[:folder_items]
      @folder_items = params[:folder_items]
    else
      @folder_items = [{ document_id: params[:id], folder_id: params[:folder_id] }]
    end

    success = @folder_items.all? do |f_item|
      folder_to_update = current_user.folders.find(f_item[:folder_id])

      next true if folder_to_update.has_folder_item(f_item[:document_id])

      folder_to_update.folder_items.create!(document_id: f_item[:document_id])
    end

    flash[:notice] = t('blacklight.folder_items.add.success') unless request.xhr?

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  # Beware, :id is the Solr document_id, not the actual Bookmark id.
  # idempotent, as DELETE is supposed to be.
  # PRETTY SURE THIS METHOD IS NEVER USED!
  def destroy
    @response, @document = search_service.fetch(params[:id])
    folder_item = current_user.existing_folder_item_for(params[:id])

    # success = (!folder_item) || FolderItem.find(folder_item).destroy

    Bpluser::Folder.find(folder_item.folder_id).touch
    Bpluser::FolderItem.find(folder_item.id).destroy

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def clear
    @folder = current_user.folders.find(params[:id])

    if @folder.folder_items.clear
      @folder.touch
      flash[:notice] = I18n.t('blacklight.folder_items.clear.success')
    else
      flash[:error] = I18n.t('blacklight.folder_items.clear.failure')
    end
    redirect_to folders_path(@folder)
  end

  # PRETTY SURE THIS METHOD IS NEVER USED!
  def delete_selected
    @folder = Bpluser::Folder.find(params[:id])

    if params[:selected]
      if @folder.folder_items.where(:document_id => params[:selected]).delete_all
        @folder.touch
        flash[:notice] = t('blacklight.folders.update_items.remove.success')
      else
        flash[:error] = t('blacklight.folders.update_items.remove.failure')
      end
      redirect_to folders_path(@folder)
    else
      flash[:error] = t('blacklight.folders.update_items.remove.no_items')
      redirect_to :back
    end
  end

  protected

  def verify_user
    flash[:notice] = I18n.t('blacklight.folders.need_login') and raise Blacklight::Exceptions::AccessDenied unless current_user
  end
end
