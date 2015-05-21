require 'rails_helper'

RSpec.describe PhotosetServices::GetList do
  let(:user) { build_stubbed(:user) }
  let(:flickr_client) { instance_double('Flickraw::Flickr') }
  let(:service) { described_class.new(user, client: flickr_client) }
  let(:data) {[
      {
          'id' => 'ABC_123',
          'title' => 'Kitties Gone Wild Volume 69',
          'description' => 'So much fur.',
          'primary' => 'PRIMARY_ID',
          'primary_photo_extras' => {
              'url_q' => 'square.jpg'
          }
      }
  ]}
  let(:photoset) { service.call.first }
  before { allow(flickr_client).to receive_message_chain(:photosets, :getList).and_return(data) }

  describe '.call' do
    it 'imports from flickr.photosets.getList' do
      expect(flickr_client).to receive_message_chain(:photosets, :getList).with(
          user_id: user.flickr_uid,
          primary_photo_extras: 'url_q',
          foo: :bar
      ).and_return([])
      service.call(foo: :bar)
    end

    it 'takes a block which operates on each photoset' do
      photosets = service.call { |set, raw| set.title = raw['title'].reverse }
      expect(photosets.first.title).to eq 'Kitties Gone Wild Volume 69'.reverse
    end

    context 'the resulting photosets' do
      it 'has the correct flickr_uid' do
        expect(photoset.flickr_uid).to eq 'ABC_123'
      end
      it 'has the correct title' do
        expect(photoset.title).to eq 'Kitties Gone Wild Volume 69'
      end
      it 'has the correct description' do
        expect(photoset.description).to eq 'So much fur.'
      end
      it 'belongs to the currect user' do
        expect(photoset.user).to eq user
      end
      it 'creates the primary photo' do
        expect(photoset.primary_photo.flickr_uid).to eq 'PRIMARY_ID'
      end
      it 'assigns the square url to the primary photo' do
        expect(photoset.primary_photo.square).to eq 'square.jpg'
      end
    end
  end
end