class User < ActiveRecord::Base
  rolify
  has_many :authentications
  validates_uniqueness_of :nickname, :email, case_sensitive: false
  validates_uniqueness_of :flickr_uid
end