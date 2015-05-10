class User < ActiveRecord::Base
  rolify

  has_many :authentications

  validates_uniqueness_of :nickname, :email, case_sensitive: false
  validates_uniqueness_of :flickr_uid

  # @return [User]
  # @param [Hash] auth_hash
  def self.new_from_omniauth(auth_hash)
    new(attrs_from_omniauth(auth_hash))
  end

  protected
  # @notice that the attributes are copied instead of sliced to avoid issues with mass assignment protection.
  def self.attrs_from_omniauth(auth_hash)
    {
        name: auth_hash[:info][:name],
        nickname: auth_hash[:info][:nickname],
        email: auth_hash[:info][:email],
        flickr_uid: auth_hash[:uid]
    }
  end
end