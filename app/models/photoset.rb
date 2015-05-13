class Photoset < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :flickr_uid
  validates_uniqueness_of :title


  # Imports photosets from `flickr.photosets.getList`.
  # The user_id params is required - any additional hash arguments will be forwarded to
  # @param [String] user_id
  # @param [Hash] kwargs
  # @yield [photoset, raw_data]
  #   @yieldreturn [Photoset]
  def self.import user_id:, **kwargs, &block
    result = flickr.photosets.getList(user_id: user_id)
    photosets = result.map do |raw|
      set = create_with(
          title: raw["title"],
          description: raw["description"]
      ).find_or_initialize_by(flickr_uid: raw["id"])
      yield(set, raw) if block_given?
      set
    end
  end
end