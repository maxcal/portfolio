class Photoset < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :flickr_uid
  validates_uniqueness_of :title
end