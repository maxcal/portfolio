class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_filter :set_config


  def set_config
    @config = Site::Configuration.active.first_or_initialize(site_title: 'Portfolio')
  end

end
