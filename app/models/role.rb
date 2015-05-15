# Used for role based authorization.
# @see https://github.com/RolifyCommunity/rolify
class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  AVAILABLE_ROLES = %w{ visitor admin }

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  validates :name,
            inclusion: { :in => AVAILABLE_ROLES }

  scopify
end
