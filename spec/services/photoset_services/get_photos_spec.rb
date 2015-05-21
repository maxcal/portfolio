require "rails_helper"

RSpec.describe PhotosetServices::GetPhotos do

  let(:photoset) { build_stubbed(:photoset, user: build_stubbed(:user) ) }
  let(:flickr_client) { instance_double('Flickraw::Flickr') }
  let(:data){
    {
        'photo' => [
            {
                "id"=>"ABC_123",
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
  let(:service) { described_class.new(photoset, client: flickr_client) }

  before { allow(flickr_client).to receive_message_chain(:photosets, :getPhotos).and_return(data) }

  it "calls flickr.photosets.getPhotos with the correct parameters" do
    expect(flickr_client).to receive_message_chain(:photosets, :getPhotos).with(
       user_id: photoset.user.flickr_uid,
       photoset_id: photoset.flickr_uid,
       extras: "date_taken,url_q,url_t,url_s,url_m,url_o",
       foo: :bar
     ).and_return(data)
    service.call(foo: :bar)
  end

  it 'finds photos if they already exist' do
    expect_any_instance_of(Photo::ActiveRecord_Relation).to \
        receive(:find_or_initialize_by).with(flickr_uid: 'ABC_123').and_call_original
    service.call
  end

  it 'takes a block which operates on each photo' do
    photos = service.call { |set, raw| set.title = raw['title'].reverse }
    expect(photos.first.title).to eq 'Yet another sunset pic.'.reverse
  end

  it "clear the photos association to avoid duplicates" do
    expect(photoset.photos).to receive(:clear)
    service.call
  end

  it "returns an association" do
    expect(service.call).to be_a ActiveRecord::Associations::CollectionProxy
  end

  context 'the resulting photos' do
    subject(:photo) { service.call.first }
    its(:title) { should eq "Yet another sunset pic." }
    its(:flickr_uid) { should eq 'ABC_123' }
    its(:date_taken) { should eq '2014-03-22 00:00:00.000000000 +0000'}
    its(:small) { should eq 's.jpg' }
    its(:square) { should eq 'sq.jpg' }
    its(:medium) { should eq 'm.jpg' }
    its(:original) { should eq 'o.jpg' }
  end
end