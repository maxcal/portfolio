module PhotosetsHelper
  def field_for_photoset(photoset, field, **kwargs)
    options = kwargs.merge(
        class: field.to_s
    )
    hidden_field_tag("photoset[#{field.to_s}]", photoset.send(field), options)
  end
end
