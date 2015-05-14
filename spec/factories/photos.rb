# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    sequence(:flickr_uid, 123){ |n| "FID#{n}" }
  end
end