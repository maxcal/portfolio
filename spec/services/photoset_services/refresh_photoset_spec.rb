require 'rails_helper'

RSpec.describe PhotosetServices::RefreshPhotoset do

  describe '#call' do
    let(:photoset) { build_stubbed(:photoset, user: build_stubbed(:user) ) }
    let(:flickr_client) { instance_double('Flickraw::Flickr') }
    let(:service) { described_class.new(photoset, flickr_client) }
    let(:data) {
      {
          'id' => 'ABC_123',
          'title' => 'Kitties Gone Wild Volume 69',
          'description' => 'So much fur.',
          'primary' => 'NEW_PRIMARY_ID',
          'primary_photo_extras' => {
              'url_q' => 'square.jpg'
          }
      }
    }
    let(:photo_data){
      {
          'photo' => [
              {
                  "id"=>"NEW_PRIMARY_ID",
                  "secret"=>"73945d3830",
                  "server"=>"7300",
                  "farm"=>8,
                  "title"=>"Yet another sunset pic.",
                  "isprimary"=>"1",
                  "ispublic"=>1,
                  "isfriend"=>0,
                  "isfamily"=>0,
                  "datetaken"=>"2014-03-22    17=>48=>30",
                  "datetakengranularity"=>"0",
                  "datetakenunknown"=>0,
                  "url_q"=>"sq.jpg",
                  "height_sq"=>75,
                  "width_sq"=>75,
                  "url_t"=>"t.jpg",
                  "height_t"=>"100",
                  "width_t"=>"67",
                  "url_s"=>"s.jpg",
                  "height_s"=>"240",
                  "width_s"=>"160",
                  "url_m"=>"m.jpg",
                  "height_m"=>"500",
                  "width_m"=>"333",
                  "url_o"=>"o.jpg",
                  "height_o"=>"4256",
                  "width_o"=>"2832"
              }
          ]
      }
    }

    before do
      allow(flickr_client).to receive_message_chain(:photosets, :getInfo).and_return(data)
      allow(flickr_client).to receive_message_chain(:photosets, :getPhotos).and_return(photo_data)
    end

    it "calls photosets.getInfo with the correct params" do
      expect(flickr_client).to receive_message_chain(:photosets, :getInfo).with(
                                   api_key: ENV['FLICKR_KEY'],
                                   user_id: photoset.user.flickr_uid,
                                   photoset_id: photoset.flickr_uid
                               ).and_return(data)
      service.call
    end
    it "gets photos" do
      expect(flickr_client).to receive_message_chain(:photosets, :getPhotos)
      service.call
    end
    it "updates title" do
      service.call
      expect(photoset.title).to eq 'Kitties Gone Wild Volume 69'
    end
    it "updates description" do
      service.call
      expect(photoset.description).to eq 'So much fur.'
    end
    it "assigns new primary photo" do
      service.call
      expect(photoset.primary_photo.flickr_uid).to eq 'NEW_PRIMARY_ID'
    end
    it "assigns photos" do
      service.call
      expect(photoset.photos.any?).to be_truthy
    end
  end
end