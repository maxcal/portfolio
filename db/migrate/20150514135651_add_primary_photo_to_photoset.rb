class AddPrimaryPhotoToPhotoset < ActiveRecord::Migration
  def change
    add_reference :photosets, :primary_photo, index: true
    # add_foreign_key :photosets, :photos, column: :primary_photo_id, on_delete: :cascade
  end
end
