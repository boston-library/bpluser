module Bpluser
  class APIController < ActionController::Base

    def sdf
      JSON.parse(request.body.read) #What does this do?
    end
  end
end
