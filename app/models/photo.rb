class Photo < ActiveRecord::Base
  has_and_belongs_to_many :photosets
  validates_uniqueness_of :flickr_uid

  alias_attribute :url_s, :small
  alias_attribute :url_sq, :square
  alias_attribute :url_m, :medium
  alias_attribute :url_o, :original
  alias_attribute :datetaken, :date_taken # Because Flickr is very inconsistent...

end
