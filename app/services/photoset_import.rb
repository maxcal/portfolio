class PhotosetImport

  # @param [User] user (required)
  # @param [Flickraw::Flickr] client (optional) can be used in tests to stub out flickraw
  def initialize(user, client: flickr)
    @user = user
    @client = client
  end

  # Imports photosets from `flickr.photosets.getList`.
  # @note The photos are not persisted.
  # @param [Hash] **kwargs (optional) any additional hash arguments forwarded to the api call.
  # @yield [photoset, raw_data] - yields the Photoset and raw data to the optional block.
  # @return [Array]
  # @see https://www.flickr.com/services/api/flickr.photosets.getList.html
  def call **kwargs
    options = kwargs.merge(
        user_id: @user.flickr_uid,
        primary_photo_extras: 'url_q'
    )
    @client.photosets.getList(options).map do |raw|
      set = Photoset.create_with(
          title: raw['title'],
          description: raw['description'],
          user: @user,
          primary_photo_attributes: {
              flickr_uid: raw['primary'],
              square: raw['primary_photo_extras'].try(:[], 'url_q')
          }
      ).find_or_initialize_by(flickr_uid: raw['id'])
      yield(set, raw) if block_given?
      set
    end
  end
end