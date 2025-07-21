# frozen_string_literal: true

class CommonwealthSearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include CommonwealthVlrEngine::SearchBuilderBehavior

  self.default_processor_chain += [
    :institution_limit, :exclude_institutions, :exclude_collections,
    :site_filter, :exclude_unwanted_models, :exclude_unpublished_items,
    :add_adv_search_clauses
  ]

  self.default_processor_chain += [:institution_limit, :exclude_institutions] unless I18n.t('blacklight.home.browse.institutions.enabled')
end
