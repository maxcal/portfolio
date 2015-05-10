class Authentication < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :uid, scope: :provider

  # @return [Hash]
  # @param [Hash] auth_hash
  #   @see https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
  def self.attr_from_omniauth(auth_hash)
    {
        uid: auth_hash[:uid],
        provider: auth_hash[:provider].to_sym,
        token: auth_hash[:credentials][:token]
    }
  end

  # @param [Hash] auth_hash
  #   @see https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
  # @return [User]
  def update_from_omniauth!(auth_hash)
    update!(
        token: auth_hash[:credentials][:token]
    )
  end

  # @param [Hash] auth_hash
  #   @see https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
  # @return [User]
  def self.create_from_omniauth(auth_hash)
    create(attr_from_omniauth(auth_hash))
  end
end
