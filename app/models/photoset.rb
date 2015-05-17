class Photoset < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :photos
  # @note We define the relationsship as belongs_to instead of has_one
  #   since we want to store the foreign key on photosets - not photo.
  belongs_to :primary_photo, class_name: 'Photo'
  accepts_nested_attributes_for :primary_photo
  validates_uniqueness_of :flickr_uid, nil: false
  validates_uniqueness_of :title
end