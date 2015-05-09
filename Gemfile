source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
gem 'flickraw-cached', '~> 20120701'

#=== Front-end ==============================
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as the compressor for JavaScript assets
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'simple_form', '~> 3.1.0'
gem 'foundation-rails', '~> 5.5.2.1'

#=== Database ==============================
gem 'pg', '~> 0.18.1'

#== Security ===============================
gem 'warden', '~> 1.2.3' # Rack middleware that provides authentication
gem 'omniauth-flickr', '~> 0.0.15' # Flickr Oauth authentication flow
gem 'cancancan', '~> 1.10.1' # Simple authorization solution for Rails
gem 'rolify', '~> 4.0.0' # Roles library without any authorization enforcement

group :doc do
  gem 'yard', '~> 0.8.7.6'
end

group :development, :test do
  gem 'spring'
  gem 'dotenv-rails', '~> 2.0.0' # Loads env vars from .env file
  gem 'database_cleaner', '~> 1.4.1'
  gem 'rspec-rails', '~> 3.2.1'
  gem "guard-rspec", "~> 4.5", require: false
  gem 'guard-livereload', require: false
  gem "terminal-notifier-guard", require: false # Show test status indicators on Mac OS X
  gem "factory_girl_rails", "~> 4.4.1"
end

group :development do
  gem 'byebug' # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'better_errors' # better error pages
  gem 'meta_request' # used for RailsPanel in Google Chrome
  gem 'web-console'  # Access an IRB console on exception pages or by using <%= console %> in views
end

group :test do
  gem 'webmock', '~> 1.20.4' # WebMock allows stubbing HTTP requests and setting expectations on HTTP requests.
  gem 'launchy', require: false # Opens browser with page Capybara is processing if we do `fail_and_save_page!`
  gem 'capybara', '~> 2.4.4'
  gem 'rspec-its', '~> 1.2.0'
  gem 'vcr', '~> 2.9.3'
  gem 'poltergeist', '~> 1.6.0' # Phantom.js driver for Capybara
end

group :production do
  gem 'rails_12factor', '~> 0.0.3' # Run Rails the 12factor way. Required by Heroku
end