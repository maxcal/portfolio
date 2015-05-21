module PhotosetServices
  class RefreshPhotoset

    def initialize(photoset, client = flickr)
      @photoset = photoset
      @client = client
    end

    def call
      response = @client.photosets.getInfo(
          api_key: ENV['FLICKR_KEY'],
          photoset_id: @photoset.flickr_uid,
          user_id: @photoset.user.flickr_uid
      )
      photos = PhotosetServices::GetPhotos.new(@photoset, client: @client).call
      primary = photos.find { |p| p.flickr_uid = response["primary"] }
      @photoset.update!(
         title: response["title"],
         description: response["description"],
         primary_photo: primary,
         photos: photos
      )
    end
  end
end