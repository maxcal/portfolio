module PhotosetsHelper
  # Creates a hidden field for a photoset attribute
  # @param [Photoset] photoset
  # @param [Symbol] field
  # @param [Hash] kwargs - a hash of parameters passed to {ActionView::Helpers::FormTagHelper.hidden_field_tag}
  # @return [String]
  def field_for_photoset(photoset, field, **kwargs)
    hidden_field_tag("photoset[#{field.to_s}]", photoset.send(field), kwargs.merge(
        id: nil
    ))
  end
  # Creates a hidden field for a photosets nested primary photo
  # @param [Photo] primary_photo
  # @param [Symbol] field
  # @param [Hash] kwargs - a hash of parameters passed to {ActionView::Helpers::FormTagHelper.hidden_field_tag}
  # @return [String]
  def field_for_primary_photo(primary_photo, field, **kwargs)
    hidden_field_tag("photoset[primary_photo_attributes][#{field.to_s}]", primary_photo.send(field), kwargs.merge(
        id: nil
    ))
  end
end