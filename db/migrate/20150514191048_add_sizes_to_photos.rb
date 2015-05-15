class AddSizesToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :square, :string
    add_column :photos, :small, :string
    add_column :photos, :medium, :string
    add_column :photos, :original, :string
  end
end
