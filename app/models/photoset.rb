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
    options = kwargs.merge(
        user_id: user.flickr_uid,
        primary_photo_extras: 'url_sq, url_t, url_s, url_m, url_o'
    )
    result = flickr.photosets.getList(options)
    photosets = result.map do |raw|
      set = create_with(
          title: raw["title"],
          description: raw["description"],
          user: user,
          primary_photo_attributes: {
              flickr_uid: raw['primary'],
              url_s: raw['primary_photo_extras']['url_s'],
              url_sq: raw['primary_photo_extras']['url_sq'],
              url_m: raw['primary_photo_extras']['url_m'],
              url_o: raw['primary_photo_extras']['url_o'],
          }
      ).find_or_initialize_by(flickr_uid: raw["id"])
      yield(set, raw) if block_given?
      set
    end
  end
end