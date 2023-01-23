# frozen_string_literal: true

module RedirectQueryParamsHelper
  def referer_query_params(response)
    return {} if response.blank? || response.redirect_url.blank?

    parsed = URI.parse(response.redirect_url)
    Rack::Utils.parse_nested_query(parsed.query)
  rescue StandardError
    {}
  end
end

RSpec.configure do |config|
  config.include RedirectQueryParamsHelper, type: :controller
end
