class Photo < ActiveRecord::Base
  has_and_belongs_to_many :photosets
  validates_uniqueness_of :flickr_uid
end
