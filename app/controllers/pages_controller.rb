class PagesController < ApplicationController

  before_filter :find_page, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:home]

  respond_to :html

  # `GET '/'`
  def home
  end

  def show
    respond_with(@page)
  end

  def edit
    respond_with(@page)
  end

  def new
    respond_with(@page)
  end

  def create
    @page.save
    respond_with(@page)
  end

  def update
    @page.update(page_params)
    respond_with(@page)
  end

  def destroy
    @page.destroy
    respond_with(@page)
  end

  private

  def page_params
    params.require(:page).permit(:title, :slug)
  end

  def find_page
    @page = Page.find_by_slug_or_id(params[:id])
  end
end
