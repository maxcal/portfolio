require 'rails_helper'
require 'json'

RSpec.describe Photo, type: :model do
  it { should have_and_belong_to_many :photosets }
  it { should validate_uniqueness_of :flickr_uid }

  describe ".attributes_from_flickr" do
    let(:raw_data) {
      {
        "id"=>"13362508473",
        "secret"=>"73945d3830",
        "server"=>"7300",
        "farm"=>8,
        "title"=>"Test Title",
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
    }
    subject { Photo.new( Photo.attributes_from_flickr(raw_data) ) }

    its(:title) { should eq 'Test Title' }
    its(:flickr_uid) { should eq '13362508473' }
    its(:date_taken) { should eq '2014-03-22 00:00:00.000000000 +0000'}
    its(:small) { should eq 's.jpg' }
    its(:square) { should eq 'sq.jpg' }
    its(:medium) { should eq 'm.jpg' }
    its(:original) { should eq 'o.jpg' }
  end
end