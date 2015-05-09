# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Joe Bloggs"
    nickname "jbloggs"
    email "jbloggs@example.com"
    flickr_uid "abc123456"
  end
end
