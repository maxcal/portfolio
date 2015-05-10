Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  OmniAuth.config.logger = Rails.logger
  provider :flickr, ENV['FLICKR_KEY'], ENV['FLICKR_SECRET'], scope: 'read'
end