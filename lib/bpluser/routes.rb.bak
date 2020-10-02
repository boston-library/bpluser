module Bpluser
  class Routes
    def initialize(router, options)
      @router = router
      @options = options
    end

    def draw
      route_sets.each do |r|
        self.send(r)
      end
    end

    protected

    def add_routes &blk
      @router.instance_exec(@options, &blk)
    end

    def route_sets
      (@options[:only] || default_route_sets) - (@options[:except] || [])
    end

    def default_route_sets
      [:omniauth_callbacks]
    end

    module RouteSets
      def omniauth_callbacks
        add_routes do |options|
          resources :omniauth_callbacks
        end
      end
    end
    include RouteSets
  end
end