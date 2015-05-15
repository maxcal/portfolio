class Photo < ActiveRecord::Base
  has_and_belongs_to_many :photosets
  validates_uniqueness_of :flickr_uid

  alias_attribute :url_s, :small
  alias_attribute :url_sq, :square
  alias_attribute :url_m, :medium
  alias_attribute :url_o, :original
  alias_attribute :datetaken, :date_taken # Because Flickr is very inconsistent...

  # @param [Hash] raw
  # @return [Hash] hash of attributes suitable for creating a photo
  def self.attributes_from_flickr(raw)
    raw = HashWithIndifferentAccess.new(raw)
    raw.slice(:title).merge(
        flickr_uid: raw[:id],
        small: raw[:url_s],
        square: raw[:url_sq],
        medium: raw[:url_m],
        original: raw[:url_o],
        datetaken: raw[:datetaken]
    )
  end
end
