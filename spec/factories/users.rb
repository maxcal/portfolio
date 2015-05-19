# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Joe Bloggs"
    sequence(:nickname) { |n| "jbloggs" + (n > 1  ? " #{n}" : "") }
    email { nickname + "@example.com" }
    sequence(:flickr_uid, 6) { |n| "abc12345#{n}" }
    factory :admin do
      after(:build)  { |user| user.add_role(:admin) }
      after(:stub)  { |user| user.add_role(:admin) }
    end

    factory :me do
      flickr_uid '62829091@N05'
    end
  end
end
