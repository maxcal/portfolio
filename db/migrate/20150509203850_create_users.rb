class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :nickname
      t.string :email
      t.string :flickr_uid

      t.timestamps null: false
    end
    add_index :users, :nickname, unique: true
    add_index :users, :email, unique: true
    add_index :users, :flickr_uid, unique: true
  end
end
