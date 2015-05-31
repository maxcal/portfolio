class Site::ConfigurationsController < ApplicationController
  load_and_authorize_resource :configuration, class: "Site::Configuration", parent: false
  respond_to :html

  def index
    respond_with(@configurations)
  end

  def show
    respond_with(@configuration)
  end

  def new
    respond_with(@configuration)
  end

  def edit
  end

  def create
    @configuration.save
    respond_with(@configuration)
  end

  def update
    @configuration.update(configuration_params)
    respond_with(@configuration)
  end

  def destroy
    @configuration.destroy
    respond_with(@configuration)
  end

  def configuration_params
    params.require(:configuration).permit(:name, :status, :site_title)
  end
end