require 'rails_helper'

RSpec.describe Page, type: :model do
  it { should validate_uniqueness_of :title }
  it { should belong_to :author }
  it "should slug the title" do
    page = Page.create(title: 'Hello World')
    expect(page.slug).to eq 'hello-world'
  end

  describe '#to_param' do
    let(:page) { build_stubbed(:page, slug: 'foo-bar') }

    it 'creates a slug' do
      expect(page.to_param).to eq 'foo-bar'
    end
  end

  describe '.find_by_slug_or_id' do
    let!(:page) { create(:page, slug: 'foo-bar') }
    it 'finds a page given a correct id' do
      expect(Page.find_by_slug_or_id(page.id)).to eq page
    end
    it 'finds a page given a correct slug' do
      expect(Page.find_by_slug_or_id(page.slug)).to eq page
    end
  end
end
