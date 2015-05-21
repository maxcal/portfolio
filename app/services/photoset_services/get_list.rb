module PhotosetServices
  class GetList

  # @param [User] user (required)
  # @param [Flickraw::Flickr] client (optional) can be used in tests to stub out flickraw
  def initialize(user, client: flickr)
    @user = user
    @client = client
  end

  # Imports photosets from `flickr.photosets.getList`.
  #   Filters out photosets which have already been imported.
  # @note The photos are not persisted.
  # @param [Hash] **kwargs (optional) any additional hash arguments forwarded to the api call.
  # @yield [photoset, raw_data] - yields the Photoset and raw data to the optional block.
  # @return [Array] an array of new Photoset.
  # @see https://www.flickr.com/services/api/flickr.photosets.getList.html
  def call **kwargs
    existing_photosets = Photoset.pluck(:flickr_uid)
    api_options = kwargs.merge(
        user_id: @user.flickr_uid,
        primary_photo_extras: 'url_q'
    )
    @client.photosets.getList(api_options).map do |raw| 
      unless existing_photosets.include? raw['id']
        set = Photoset.new(
           title: raw['title'],
           description: raw['description'],
           user: @user,
           flickr_uid: raw['id'],
           primary_photo_attributes: {
               flickr_uid: raw['primary'],
               square: raw['primary_photo_extras'].try(:[], 'url_q')
           }
        )
        yield(set, raw) if block_given?
        set
      end
    end.compact
  end
  end
end