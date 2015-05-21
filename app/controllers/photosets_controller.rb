class PhotosetsController < ApplicationController
  load_and_authorize_resource except: [:refresh]
  respond_to :html, :json

  def show
    respond_with(@photoset)
  end

  def index
    respond_with(@photoset)
  end

  # Gets photosets from Flickr and allows user to choose which ones to import
  def new
    @photosets = PhotosetServices::GetList.new(current_user).call
    respond_with(@photosets)
  end

  def create
    @photoset.user = current_user
    respond_with @photoset do |format|
      if @photoset.save
        @photos = PhotosetServices::GetPhotos.new(@photoset).call
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
    if @photoset.destroy
      flash[:notice] = t('photosets.flash.destroy.success')
    else
      flash[:notice] = t('photosets.flash.destroy.failure')
    end
    respond_with(@photoset)
  end

  def refresh
    @photoset = Photoset.find(params[:id])
    authorize! :update, @photoset
    updated = PhotosetServices::RefreshPhotoset.new(@photoset).call
    if updated
      flash[:notice] = t('photosets.flash.update.success')
    else
      flash[:error] = t('photosets.flash.update.failure')
    end
    respond_with @photoset
  end

  def photoset_params
    primary_flickr_uid = params.require(:photoset).permit(primary_photo_attributes: [:flickr_uid])
                                                  .try(:[], 'primary_photo_attributes')
                                                  .try(:[], 'flickr_uid')
    photo = Photo.find_by(flickr_uid: primary_flickr_uid)
    if photo
      params.require(:photoset)
            .permit(:title, :description, :flickr_uid).merge(primary_photo: photo)
    else
      params.require(:photoset)
            .permit(:title, :description, :flickr_uid, primary_photo_attributes: [:flickr_uid, :square])
    end
  end
end