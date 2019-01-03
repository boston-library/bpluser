module Bpluser::Ability
  #TODO Move this into concern
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def initialize(user)
      #can :read, :all
      user ||= User.new # guest user (not logged in)
      if user.superuser?
        can [:create, :show, :add_user, :edit, :remove_user, :index], Role
        can [:create, :show, :add_user, :edit, :remove_user, :index], Institution
      else
        can [:show, :index], Institution
      end


    end
  end

end
