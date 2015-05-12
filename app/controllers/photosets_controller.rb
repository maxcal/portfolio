class PhotosetsController < ApplicationController
  load_and_authorize_resource

  def show; end
  def index; end
  def new; end

  def create
    if @photoset.save
      redirect_to @photoset
    else
      render action: :new
    end
  end

  def edit; end

  def update
    if @photoset.update(photoset_params)
      redirect_to @photoset
    else
      render action: :edit
    end
  end

  def destroy
    if @photoset.destroy
      redirect_to photosets_path
    else
      redirect_to @photoset
    end
  end

  def photoset_params
    params.require(:photoset).permit(:title, :description, :flickr_uid)
  end
end