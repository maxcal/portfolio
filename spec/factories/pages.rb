# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title {|n| "Test Title #{n}"}
    slug { title.downcase.gsub(' ', '-') }
    content "Hello world"
  end
end
