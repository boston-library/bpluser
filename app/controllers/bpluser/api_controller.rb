module Bpluser
  class APIController < ActionController::Base

    def sdf
      JSON.parse(request.body.read)

    end
  end
end