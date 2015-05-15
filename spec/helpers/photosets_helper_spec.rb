require 'rails_helper'

RSpec.describe PhotosetsHelper, type: :helper do

  let(:photoset) { build_stubbed(:photoset) }
  let(:photo) { build_stubbed(:photo) }

  describe '.field_for_photoset' do
    let(:field) { Capybara::Node::Simple.new(helper.field_for_photoset(photoset, :flickr_uid)) }
    it "has the correct name" do
      expect(field.find('input')[:name]).to eq "photoset[flickr_uid]"
    end
    it "has the correct value" do
      expect(field.find('input').value).to eq photoset.flickr_uid
    end
  end

  describe '.field_for_primary_photo' do
    let(:field) { Capybara::Node::Simple.new(helper.field_for_primary_photo(photo, :flickr_uid)) }
    it "has the correct name" do
      expect(field.find('input')[:name]).to eq "photoset[primary_photo_attributes][flickr_uid]"
    end
    it "has the correct value" do
      expect(field.find('input').value).to eq photo.flickr_uid
    end
  end
end
