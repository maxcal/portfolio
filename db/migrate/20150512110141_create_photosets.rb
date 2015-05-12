class CreatePhotosets < ActiveRecord::Migration
  def change
    create_table :photosets do |t|
      t.belongs_to :user, index: true
      t.string :title
      t.string :flickr_uid
      t.text :description
      t.timestamps null: false
    end
    add_foreign_key :photosets, :users
  end
end
