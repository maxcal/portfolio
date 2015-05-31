# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :configuration, :class => 'Site::Configuration', aliases: [:config] do
    sequence(:name) {|n|  "Config-#{n}" }
    status :disabled
    site_title "Example Site Title"
  end
end
