class Site::ConfigurationsController < ApplicationController
  load_and_authorize_resource :site_configuration, class: "Site::Configuration", parent: false
  respond_to :html

  def index
    respond_with(@site_configurations)
  end

  def show
    respond_with(@site_configuration)
  end

  def new
    respond_with(@site_configuration)
  end

  def edit
  end

  def create
    @site_configuration.save
    respond_with(@site_configuration)
  end

  def update
    @site_configuration.update(site_configuration_params)
    respond_with(@site_configuration)
  end

  def destroy
    @site_configuration.destroy
    respond_with(@site_configuration)
  end

  def site_configuration_params
    params.require(:site_configuration).permit(:name, :status, :site_title)
  end
end
