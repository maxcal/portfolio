FactoryGirl.define do
  factory :photo do
    sequence(:flickr_uid, 123){ |n| "FID#{n}" }
    small 'http://example.com/s.jpg'
    square 'http://example.com/sq.jpg'
    medium 'http://example.com/m.jpg'
    original 'http://example.com/o.jpg'
  end
end