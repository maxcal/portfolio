# All permissions are defined in the CanCanCan Ability class
# @see Role
# @see https://github.com/CanCanCommunity/cancancan/
class Ability
  include CanCan::Ability

  # @param [User|nil] user the current application user.
  #   if there is no logged in user a guest user will be created
  # @see https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :update, to: :refresh
    user ||= User.new # guest user (not logged in)
    can :read, User
    can :crud, user # Users should be able to manage their own account.
    can :read, Photoset
    if user.has_role?(:admin)
      can :crud, Photoset
      can :refresh, Photoset
    end
  end
end