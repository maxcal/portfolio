module PhotosetsHelper
  def field_for_photoset(photoset, field, **kwargs)
    options = kwargs.merge(
        id: nil
    )
    hidden_field_tag("photoset[#{field.to_s}]", photoset.send(field), options)
  end

  def field_for_primary_photo(primary_photo, field, **kwargs)
    options = kwargs.merge(
        id: nil
    )
    hidden_field_tag("photoset[primary_photo_attributes][#{field.to_s}]", primary_photo.send(field), options)
  end

end
