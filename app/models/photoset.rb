class Photoset < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :photos
  # We define the relationsship as belongs_to instead of has_one
  # since we want to store the foreign key on photosets - not photo.
  belongs_to :primary_photo, class_name: 'Photo'
  accepts_nested_attributes_for :primary_photo
  validates_uniqueness_of :flickr_uid, nil: false
  validates_uniqueness_of :title

  # Imports photosets from `flickr.photosets.getList`.
  # The user_id params is required - any additional hash arguments will be forwarded to
  # @param [User] user
  # @param [Hash] kwargs
  # @yield [photoset, raw_data]
  #   @yieldreturn [Photoset]
  def self.import user:, **kwargs, &block
    result = flickr.photosets.getList(user_id: user.flickr_uid)
    photosets = result.map do |raw|
      set = create_with(
          title: raw["title"],
          description: raw["description"],
          user: user
      ).find_or_initialize_by(flickr_uid: raw["id"])
      yield(set, raw) if block_given?
      set
    end
  end
end