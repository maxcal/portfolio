FactoryGirl.define do
  factory :photoset do
    sequence(:flickr_uid, 123) {|n| "ABC#{n}" }
    sequence(:title) { |n| "Test Title #{n > 1 ? n.to_s : nil}".strip  }
    description 'A simple test photoset'
    user nil
  end
end
