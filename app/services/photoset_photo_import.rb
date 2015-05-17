class PhotosetPhotoImport

  # @param [Photoset] photoset
  # @param [Flickraw::Flickr] client (optional)
  def initialize(photoset, client: flickr)
    @photoset = photoset
    @client = client
  end

  # Get the photos for a set from `flickr.photosets.getPhotos`.
  # @note This creates new photos and updates existing photos.
  # @param [Hash] **kwargs (optional) any additional hash arguments forwarded to the api call.
  # @yield [photo, raw_data] yields the Photoset and raw data to the optional block before saving.
  # @return [ActiveRecord::Associations::CollectionProxy]
  # @see https://www.flickr.com/services/api/flickr.photosets.getPhotos.htm
  def call **kwargs, &block
    options = kwargs.merge(
        photoset_id: @photoset.flickr_uid,
        user_id: @photoset.user.flickr_uid,
        extras: 'date_taken,url_q,url_t,url_s,url_m,url_o'
    )
    results = @client.photosets.getPhotos(options)
    results["photo"].map do |raw|
      photo = Photo.find_or_initialize_by(flickr_uid: raw['id'])
      photo.assign_attributes(
          title: raw['title'],
          small: raw['url_s'],
          square: raw['url_q'],
          medium: raw['url_m'],
          original: raw['url_o'],
          datetaken: raw['datetaken']
      )
      yield(photo, raw) if block_given?
      photo.save!
      @photoset.photos << photo
      photo
    end
    @photoset.photos
  end
end