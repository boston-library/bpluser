# frozen_string_literal: true

# copied from Blacklight 6.19.2 -- this feature is no longer provided by Blacklight >= 7
module Bpluser
  module SavedSearches
    extend ActiveSupport::Concern

    included do
      include Blacklight::Configurable
      copy_blacklight_config_from(CatalogController)
      # before_action :require_user_authentication_provider This is deprecated
      before_action :verify_user
    end

    def index
      @searches = current_user.searches
    end

    def save
      current_user.searches << searches_from_history.find(params[:id])

      if current_user.save
        flash[:notice] = t('blacklight.saved_searches.add.success')
      else
        flash[:error] = t('blacklight.saved_searches.add.failure')
      end

      redirect_back fallback_location: saved_searches_path
    end

    # Only dereferences the user rather than removing the item in case it
    # is in the session[:history]
    def forget
      search = current_user.searches.find(params[:id])

      if search.update(user_id: nil)
        flash[:notice] = t('blacklight.saved_searches.remove.success')
      else
        flash[:error] = t('blacklight.saved_searches.remove.failure')
      end

      redirect_back fallback_location: saved_searches_path
    end

    # Only dereferences the user rather than removing the items in case they
    # are in the session[:history]
    def clear
      if current_user.searches.all? { |s| s.update(user_id: nil) } && current_user.save
        flash[:notice] = t('blacklight.saved_searches.clear.success')
      else
        flash[:error] = t('blacklight.saved_searches.clear.failure')
      end
      redirect_to saved_searches_url
    end

    protected

    def verify_user
      flash[:notice] = t('blacklight.saved_searches.need_login') and raise Blacklight::Exceptions::AccessDenied unless current_user
    end
  end
end
