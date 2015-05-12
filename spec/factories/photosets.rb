# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photoset do
    user nil
    sequence(:title) { |n| "Test Title" + (n > 1  ? " {n}" : "") }
    description "Just a walk in the park"
    sequence(:flickr_uid, 123) { |n| "ABC#{n}" }
  end
end
