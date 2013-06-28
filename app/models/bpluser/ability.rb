module Bpluser::Ability

  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def initialize(user)
      #can :read, :all
      if user.superuser?
        can [:create, :show, :add_user, :remove_user, :index], Role
        can [:create, :show, :add_user, :remove_user, :index], Institution
      end


    end
  end

end