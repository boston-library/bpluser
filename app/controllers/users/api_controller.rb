module Bpluser
  class APIController < ActionController::Base
    # for allowing BPL Digital Stacks favorites to be transferred to a user account
    # Digital Stacks is no longer in production, but leaving this here for now.
    def sdf
      JSON.parse(request.body.read)
    end
  end
end
