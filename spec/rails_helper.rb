ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'factory_girl'
require 'warden'
require 'vcr'
require 'capybara/poltergeist'
require 'support/controller_spec_helper'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|

  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods
  config.include Warden::Test::Helpers
  config.include ControllerSpecHelper, type: :controller

  # to allow CSS and Javascript to be loaded when we use save_and_open_page, the
  # development server must be running at localhost:3000 as specified below or
  # wherever you want. See original issue here:
  #https://github.com/jnicklas/capybara/pull/609
  # and final resolution here:
  #https://github.com/jnicklas/capybara/pull/958
  Capybara.asset_host = "http://localhost:3000"
  Capybara.javascript_driver = :poltergeist

  VCR.configure do |config|
    config.cassette_library_dir = File.expand_path(File.dirname(__FILE__) + "/support/vcr_cassettes")
    config.hook_into :webmock # or :fakeweb
    config.ignore_localhost = true
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, pre_count: true)
    DatabaseCleaner.strategy = :truncation
    Warden.test_mode!
    OmniAuth.config.test_mode = true

  end

  config.before(:each) do |ex|
    DatabaseCleaner.strategy = ex.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end
end



