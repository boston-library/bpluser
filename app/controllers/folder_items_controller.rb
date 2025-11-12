# frozen_string_literal: true

class FolderItemsController < CatalogController
  include Bpluser::FoldersVerifyUser

  before_action :verify_user

  def create
    @response, @document = search_service.fetch(params[:id])

    @folder_items = params[:folder_items].present? ? folder_items_params : default_folder_item_params

    folder_items_to_add = @folder_items.reject { |folder_item| current_user.folder_items.where(folder_item).exists? }.group_by { |fi| fi[:folder_id].to_i }

    success = ActiveRecord::Base.transaction do
      current_user.folders.where(id: folder_items_to_add.keys).find_each do |folder|
        folder.folder_items.create!(folder_items_to_add[folder.id].map { |fi| fi.slice(:document_id) })
      end
    rescue ActiveRecord::RecordInvalid
      false
    end

    unless request.xhr?
      if success
        flash[:notice] = t('blacklight.folder_items.add.success')
      else
        flash[:error] = t('blacklight.folder_items.add.failure')
      end
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back_or_to(folders_path) }
    end
  end

  def update
    create
  end

  # Beware, :id is the Solr document_id, not the actual Bookmark id.
  # idempotent, as DELETE is supposed to be.
  # PRETTY SURE THIS METHOD IS NEVER USED!
  def destroy
    @response, @document = search_service.fetch(params[:id])
    folder_item = current_user.existing_folder_item_for(params[:id])

    Bpluser::FolderItem.find(folder_item.id).destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back_or_to(root_path) }
    end
  end

  def clear
    @folder = current_user.folders.find(params[:id])

    if @folder.folder_items.clear && @folder.save
      flash[:notice] = t('blacklight.folder_items.clear.success')
    else
      flash[:error] = t('blacklight.folder_items.clear.failure')
    end
    redirect_to folders_path(@folder)
  end

  # PRETTY SURE THIS METHOD IS NEVER USED!
  def delete_selected
    @folder = Bpluser::Folder.find(params[:id])

    if params[:selected]
      if @folder.folder_items.destroy_by(document_id: params[:selected])
        flash[:notice] = t('blacklight.folders.update_items.remove.success')
      else
        flash[:error] = t('blacklight.folders.update_items.remove.failure')
      end

      redirect_to folders_path(@folder)
    else
      flash[:error] = t('blacklight.folders.update_items.remove.no_items')
      redirect_back(fallback_location: root_path)
    end
  end

  protected

  def default_folder_item_params
    [{ document_id: params[:id], folder_id: params[:folder_id] }]
  end

  def folder_items_params
    params.permit(folder_items: [:document_id, :folder_id])
  end
end
