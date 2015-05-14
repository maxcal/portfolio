class CreateJoinTablePhotoPhotoset < ActiveRecord::Migration
  def change
    create_join_table :photos, :photosets do |t|
      # t.index [:photo_id, :photoset_id]
      # t.index [:photoset_id, :photo_id]
    end
  end
end
