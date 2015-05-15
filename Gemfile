source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
gem 'flickraw-cached', '~> 20120701'
gem 'responders', '~> 2.1.0' # A set of Rails responders to dry up your application

#=== Front-end ==============================
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as the compressor for JavaScript assets
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'simple_form', '~> 3.1.0'
gem 'foundation-rails', '~> 5.5.2.1'
gem 'turbolinks', '~> 2.5.3'
gem 'foundation-icons-sass-rails', '~> 3.0.0'
gem 'underscore-rails', '~> 1.8.2'

#=== Database ==============================
gem 'pg', '~> 0.18.1'

#== Security ===============================
gem 'warden', '~> 1.2.3' # Rack middleware that provides authentication
gem 'omniauth-flickr', '~> 0.0.15' # Flickr Oauth authentication flow
gem 'cancancan', '~> 1.10.1' # Simple authorization solution for Rails
gem 'rolify', '~> 4.0.0' # Roles library without any authorization enforcement
gem 'haml', '~> 4.0.6'

group :doc do
  gem 'yard', '~> 0.8.7.6'
  gem 'yard-activerecord', '~> 0.0.14'
end

group :development, :test do
  gem 'spring'
  gem 'dotenv-rails', '~> 2.0.0' # Loads env vars from .env file
end

group :development do
  gem 'better_errors' # better error pages
  gem 'meta_request' # used for RailsPanel in Google Chrome
  gem 'guard-livereload', require: false
end

group :test do
  gem 'rspec-rails', '~> 3.2.1'
  gem 'rspec-its', '~> 1.2.0'
  gem 'database_cleaner', '~> 1.4.1'
  gem 'guard-rspec', '~> 4.5'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'webmock', '~> 1.20.4' # WebMock allows stubbing HTTP requests and setting expectations on HTTP requests.
  gem 'launchy', require: false # Opens browser with page Capybara is processing if we do `fail_and_save_page!`
  gem 'capybara', '~> 2.4.4'
  gem 'vcr', '~> 2.9.3'
  gem 'poltergeist', '~> 1.6.0' # Phantom.js driver for Capybara
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'spring-commands-rspec', '~> 1.0.4'
  if `uname` =~ /Darwin/
    gem 'terminal-notifier-guard'
    gem 'rb-fsevent'
  end
end

group :production do
  gem 'rails_12factor', '~> 0.0.3' # Run Rails the 12factor way. Required by Heroku
end