class Ability
  include CanCan::Ability

  # @see https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    user ||= User.new # guest user (not logged in)
    can :read, User
    can :crud, user # Users should be able to manage their own account.
    can :read, Photoset

    if user.has_role?(:admin)
      can :crud, Photoset
    end

  end
end