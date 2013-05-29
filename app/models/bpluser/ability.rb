module Bpluser::Ability

  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def initialize(user)
      can :read, :all
    end
  end

end