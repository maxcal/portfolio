require 'rails_helper'

RSpec.describe PhotosetsHelper, type: :helper do

  let(:photoset) { create(:photoset) }

  describe '.field_for_photoset' do
    let(:field) { Capybara::Node::Simple.new(helper.field_for_photoset(photoset, :flickr_uid)) }
    it "has the correct class" do
      expect(field).to have_selector '.flickr_uid'
    end
    it "has the correct name" do
      expect(field.find('input')[:name]).to eq "photoset[flickr_uid]"
    end
    it "has the correct value" do
      expect(field.find('input').value).to eq photoset.flickr_uid
    end
  end
end
