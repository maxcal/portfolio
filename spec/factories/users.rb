# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Joe Bloggs"
    nickname "jbloggs"
    email "jbloggs@example.com"
    flickr_uid "abc123456"

    factory :admin do
      after(:build)  { |user| user.add_role(:admin) }
      after(:stub)  { |user| user.add_role(:admin) }
    end

    factory :me do
      flickr_uid '62829091@N05'
    end
  end
end
