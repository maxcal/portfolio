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
  describe '.import' do
    let(:user) { create(:user, flickr_uid: '62829091@N05') }
    let(:photosets) do
      sets = nil
      VCR.use_cassette('photosets_import') do
        sets = Photoset.import(user: user)
      end
      sets
    end
    it "gets photosets" do
      expect(photosets.first).to be_a Photoset
    end
    it "sets flickr_uid" do
      expect(photosets.first.flickr_uid).to eq '72157647753138397'
    end
    it "sets title" do
      expect(photosets.first.title).to eq 'Showcase'
    end
    it "sets the description" do
      expect(photosets.first.description).to eq "Like a greatest hits collection, but with snow."
    end
    it "sets the user" do
      expect(photosets.first.user).to eq user
    end
    it "yields the results and raw data to a block" do
      sets = nil
      VCR.use_cassette('photosets_import') do
        sets = Photoset.import(user: user) do |set, raw|
          set.title = raw["title"].reverse
        end
      end
      expect(sets.first.title).to eq 'Showcase'.reverse
    end
    it 'imports the primary photo' do
      expect(photosets.first.primary_photo).to be_a Photo
    end
  end

  describe '.get_photos!' do
    let(:photoset){ create(:photoset, flickr_uid: "72157647753138397", user: create(:me)) }
    before do |ex|
      create(:photo, flickr_uid: '8643528260')
      VCR.use_cassette('photosets_get_photos') do
        photoset.get_photos!
      end unless ex.metadata[:skip_get_photos]
    end
    it "returns an association", skip_get_photos: true do
      VCR.use_cassette('photosets_get_photos') do
        expect(photoset.get_photos!).to be_a ActiveRecord::Associations::CollectionProxy
      end
    end
    it "sets flickr_uid" do
      expect(photoset.photos.last.flickr_uid).to eq '8234167823'
    end
    it "sets the small url" do
      expect(photoset.photos.last.small).to eq "https:\/\/farm9.staticflickr.com\/8479\/8234167823_28bd0cabe4_m.jpg"
    end
    it "updates the properties for existing photos" do
      expect(photoset.photos.first.small).to eq "https:\/\/farm9.staticflickr.com\/8522\/8643528260_ecdfeeeac2_m.jpg"
    end
    it "sets the title" do
      expect(photoset.photos.first.title).to eq "DSC_7579.jpg"
    end
    it "sets the date_taken" do
      expect(photoset.photos.first.date_taken).to eq "2013-04-12 14:54:11.000000000 +0000"
    end
    it "sets sizes" do
      expect(photoset.photos.last.square).to_not be_nil
      expect(photoset.photos.last.medium).to_not be_nil
      expect(photoset.photos.last.original).to_not be_nil
    end
    it "accepts a block with the photo and raw data as parameters", skip_get_photos: true  do
      VCR.use_cassette('photosets_get_photos') do
        photoset.get_photos! do |photo, raw|
          photo.title = raw['id']
        end
      end
      expect(photoset.photos.first.title).to eq photoset.photos.first.flickr_uid
    end
  end
end