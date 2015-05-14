class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :flickr_uid
      t.string :title
      t.timestamps null: false
    end
  end
end
