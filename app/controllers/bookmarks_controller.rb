# frozen_string_literal: true

class BookmarksController < CatalogController
  include Blacklight::Bookmarks

  # LOCAL OVERRIDE to render update.js.erb partial when bookmark created
  def create
    @bookmarks = params[:bookmarks].present? ? bookmark_params : default_bookmark_params

    current_or_guest_user.save! unless current_or_guest_user.persisted?

    success = @bookmarks.all? do |bookmark|
      next true if current_or_guest_user.bookmarks.exists?(bookmark)

      begin
        current_or_guest_user.bookmarks.create!(bookmark)
        next true
      rescue ActiveRecord::RecordInvalid
        break false
      end
    end

    if request.xhr?
      # success ? render(json: { bookmarks: { count: current_or_guest_user.bookmarks.count }}) : render(:text => "", :status => "500")
      success ? render(:update) : render(plain: '', status: :internal_server_error)
    else
      if @bookmarks.any? && success
        flash[:notice] = I18n.t('blacklight.bookmarks.add.success', count: @bookmarks.count)
      elsif @bookmarks.any?
        flash[:error] = I18n.t('blacklight.bookmarks.add.failure', count: @bookmarks.count)
      end

      redirect_back fallback_location: bookmarks_path
    end
  end

  def folder_item_actions
    redirect_to action: 'index'
  end

  private

  def default_bookmark_params
    [{ document_id: params[:id], document_type: blacklight_config.document_model.to_s }]
  end

  def bookmark_params
    params.require(:bookmarks).map { |item_params| item_params.permit(:document_id, :document_type) }
  end
end
