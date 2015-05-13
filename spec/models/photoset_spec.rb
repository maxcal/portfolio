require 'rails_helper'

RSpec.describe Photoset, type: :model do
  it { should validate_uniqueness_of :flickr_uid }
  it { should validate_uniqueness_of :title }

  describe '.import' do
    let(:photosets) do
      sets = nil
      VCR.use_cassette('photosets_import') do
        sets = Photoset.import(user_id: '62829091@N05')
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
      expect(photosets.first.description).to eq 'Test description'
    end

    it "yields the results and raw data to a block" do
      sets = nil
      VCR.use_cassette('photosets_import') do
        sets = Photoset.import(user_id: '62829091@N05') do |set, raw|
          set.title = raw["title"].reverse
        end
      end
      expect(sets.first.title).to eq 'Showcase'.reverse
    end
  end
end
