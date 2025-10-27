# frozen_string_literal: true

module Bpluser
  class BookmarksToolbarComponent < ViewComponent::Base
    attr_reader :document_ids

    def initialize(document_ids:)
      @document_ids = document_ids
      super
    end

    def citation_href
      polymorphic_path(:citation_solr_documents, sort: params[:sort], per_page: params[:per_page], id: document_ids)
    end

    def email_href
      email_bookmarks_path(sort: params[:sort], per_page: params[:per_page], id: document_ids)
    end

    def bookmark_type
      request.path.include?('articles') ? 'article' : 'catalog'
    end
  end
end
