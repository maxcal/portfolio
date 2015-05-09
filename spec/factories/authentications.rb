# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    uid "MyString"
    user nil
    provider "MyString"
    token "MyString"
    expires_at "2015-05-09 23:07:26"
  end
end
