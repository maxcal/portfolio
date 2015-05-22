module PhotosetServices
  # Updates a Photoset from Flickr
  # @note will also update all photos
  class RefreshPhotoset

    # @param [Photoset] photoset
    # @param [Flickraw::Flickr] client (optional) can be used in tests to stub out flickraw.
    def initialize(photoset, client = flickr)
      @photoset = photoset
      @client = client
    end

    # @param [Hash] kwargs Any additional hash arguments are forwarded to the api call.
    # @return [Boolean]
    def call **kwargs
      response = @client.photosets.getInfo(kwargs.merge(
                                               api_key: ENV['FLICKR_KEY'],
                                               photoset_id: @photoset.flickr_uid,
                                               user_id: @photoset.user.flickr_uid
                                           )
      )
      photos = PhotosetServices::GetPhotos.new(@photoset, client: @client).call
      primary = photos.find { |p| p.flickr_uid = response["primary"] }
      @photoset.update!(
          title: response["title"],
          description: response["description"],
          primary_photo: primary
      )
    end
  end
end