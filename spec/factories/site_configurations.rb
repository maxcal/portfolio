# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site_configuration, :class => 'Site::Configuration', aliases: [:config] do
    sequence(:name) {|n|  "Config-#{n}" }
    status 1
    site_title "Example Site Title"
  end
end
