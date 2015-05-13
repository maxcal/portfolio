class PhotosetsController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json

  def show
    respond_with(@photoset)
  end

  def index
    respond_with(@photoset)
  end

  def new
    @photosets = Photoset.import(user: current_user).select(&:new_record?)
    respond_with(@photosets)
  end

  def create
    @photoset.user = current_user
    respond_with @photoset do |format|
      if @photoset.save
        format.html { redirect_to @photoset }
      else
        format.html { render action: :new }
      end
    end
  end

  def edit
  end

  def update
    respond_with @photoset do |format|
      if @photoset.update(photoset_params)
        format.html { redirect_to @photoset }
      else
        format.html { render action: :edit }
      end
    end
  end

  def destroy
    @photoset.destroy
    respond_with(@photoset)
  end

  def photoset_params
    params.require(:photoset).permit(:title, :description, :flickr_uid)
  end
end