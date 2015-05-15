class Photoset < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :photos
  # @note We define the relationsship as belongs_to instead of has_one
  #   since we want to store the foreign key on photosets - not photo.
  belongs_to :primary_photo, class_name: 'Photo'
  accepts_nested_attributes_for :primary_photo
  validates_uniqueness_of :flickr_uid, nil: false
  validates_uniqueness_of :title

  # Imports photosets from `flickr.photosets.getList`.
  # @note The photos are not persisted.
  # @param [User] user (required)
  # @param [Hash] **kwargs (optional) any additional hash arguments forwarded to the api call.
  # @yield [photoset, raw_data] - yields the Photoset and raw data to the optional block.
  # @return [Array]
  # @see https://www.flickr.com/services/api/flickr.photosets.getList.html
  def self.import user:, **kwargs, &block
    options = kwargs.merge(
        user_id: user.flickr_uid,
        primary_photo_extras: 'url_sq, url_t,url_s,url_m,url_o'
    )
    result = flickr.photosets.getList(options)
    result.map do |raw|
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

  # Get the photos for a set from `flickr.photosets.getPhotos`.
  # @note This creates new photos and updates existing photos.
  # @param [Hash] **kwargs (optional) any additional hash arguments forwarded to the api call.
  # @yield [photo, raw_data] yields the Photoset and raw data to the optional block before saving.
  # @return [ActiveRecord::Associations::CollectionProxy]
  # @see https://www.flickr.com/services/api/flickr.photosets.getPhotos.htm
  def get_photos! **kwargs, &block
    options = kwargs.merge(
        photoset_id: flickr_uid,
        user_id: user.flickr_uid,
        extras: 'url_sq,url_t,url_s,url_m,url_o',
    )
    results = flickr.photosets.getPhotos(options)
    results['photo'].each do |raw|
      photo = Photo.find_or_initialize_by(flickr_uid: raw['id'])
      photo.assign_attributes(
          title: raw['title'],
          small: raw['url_s'],
          square: raw['url_sq'],
          medium: raw['url_m'],
          original: raw['url_o']
      )
      yield(photo, raw) if block_given?
      photo.save!
      self.photos << photo
    end
    self.photos
  end
end