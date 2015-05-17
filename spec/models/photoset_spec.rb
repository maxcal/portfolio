require 'rails_helper'

RSpec.describe Photoset, type: :model do

  it { should validate_uniqueness_of :flickr_uid }
  it { should validate_uniqueness_of :title }
  it { should have_and_belong_to_many :photos }
  it { should belong_to :primary_photo }

  it 'should accept nested parameters for primary photo' do
    set = Photoset.new(primary_photo_attributes: { flickr_uid: 'ABC' }, flickr_uid: 1234)
    expect(set.primary_photo.flickr_uid).to eq 'ABC'
  end
end