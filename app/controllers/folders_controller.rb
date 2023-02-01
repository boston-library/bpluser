# frozen_string_literal: true

class FoldersController < CatalogController
  ##
  # Give Bookmarks access to the CatalogController configuration
  include Blacklight::Configurable
  include Blacklight::TokenBasedUser
  include Bpluser::FoldersVerifyUser

  copy_blacklight_config_from(CatalogController)

  # Blacklight uses #search_action_url to figure out the right URL for
  # the global search box
  def search_action_url(options = {})
    search_catalog_url(options.except(:controller, :action))
  end
  helper_method :search_action_url

  before_action :verify_user, except: [:index, :show, :public_list]
  before_action :check_visibility, only: [:show]
  before_action :correct_user_for_folder, only: [:update, :edit, :destroy]

  blacklight_config.track_search_session = false
  blacklight_config.http_method = Blacklight::Engine.config.bookmarks_http_method

  def index
    @folders = current_or_guest_user.folders.with_folder_items if current_or_guest_user
  end

  def show
    # @folder is set by correct_user_for_folder
    @folder_items = @folder.folder_items
    folder_items_ids = @folder_items.pluck(:document_id)
    params[:sort] ||= 'title_info_primary_ssort asc, date_start_dtsi asc'
    @response, @document_list = search_service.fetch(folder_items_ids)
  end

  def new
    @folder = current_user.folders.build
  end

  def edit; end

  def create
    @folder = current_user.folders.new(folder_params)

    if @folder.save
      flash[:notice] = t('blacklight.folders.create.success')
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def update
    # @folder is set by correct_user_for_folder
    if @folder.update(folder_params)
      flash[:notice] = t('blacklight.folders.update.success')
      redirect_to @folder
    else
      render action: :edit
    end
  end

  def destroy
    # @folder is set by correct_user_for_folder
    @folder.destroy
    flash[:notice] = t('blacklight.folders.delete.success')
    redirect_to action: 'index'
  end

  # return a list of publicly visible folders that have items
  def public_list
    @folders = Bpluser::Folder.public_list
  end

  private

  def folder_params
    params.require(:folder).permit(:title, :description, :visibility)
  end

  def check_visibility
    @folder = Bpluser::Folder.with_folder_items.find(params[:id])

    return if @folder&.public?

    correct_user_for_folder
  end

  def correct_user_for_folder
    @folder ||= Bpluser::Folder.with_folder_items.find(params[:id])

    if current_or_guest_user
      flash[:notice] = t('blacklight.folders.private') and redirect_to root_path unless current_or_guest_user.folders.include?(@folder)
    else
      flash[:notice] = t('blacklight.folders.private') and redirect_to root_path
    end
  end
end
