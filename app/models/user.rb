class User < ActiveRecord::Base
  validates_uniqueness_of :nickname, :email, case_sensitive: false
  validates_uniqueness_of :flickr_uid
end