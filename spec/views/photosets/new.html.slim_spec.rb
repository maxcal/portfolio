require "rails_helper"

RSpec.describe 'photosets/new.html.slim' do

  let(:user) { build_stubbed(:user) }
  let(:photosets) { (1..5).map { build_stubbed(:photoset, user: user, primary_photo: build_stubbed(:photo)) } }
  let(:page){ Capybara::Node::Simple.new(rendered) }

  before do
    assign(:photosets, photosets)
    render
  end

  it "contains the title of each photoset" do
    expect(rendered).to have_content photosets.first.title
    expect(rendered).to have_content photosets.last.title
  end
  it 'has the flickr_uid as a hidden input' do
    input = page.find('input[name="photoset[flickr_uid]"]', match: :first)
    expect(input.value).to eq photosets.first.flickr_uid
  end
  it 'has the title as a hidden input' do
    input = page.find('input[name="photoset[title]"]', match: :first)
    expect(input.value).to eq photosets.first.title
  end
  it 'has the description as a hidden input' do
    input = page.find('input[name="photoset[description]"]', match: :first)
    expect(input.value).to eq photosets.first.description
  end
  it 'has the user id as a hidden input' do
    input = page.find('input[name="photoset[user_id]"]', match: :first)
    expect(input.value).to eq photosets.first.user_id.to_s
  end

  describe 'nests inputs for primary_photo' do
    let(:photo) { photosets.first.primary_photo }
    it 'has the primary photo flickr_uid' do
      input = page.find('input[name="photoset[primary_photo_attributes][flickr_uid]"]', match: :first)
      expect(input.value).to eq photo.flickr_uid
    end
  end
end