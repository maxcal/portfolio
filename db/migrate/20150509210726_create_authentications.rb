class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :uid
      t.belongs_to :user, index: true
      t.string :provider
      t.string :token
      t.datetime :expires_at
      t.timestamps null: false
    end
    add_index :authentications, [:provider, :uid], unique: true
    add_foreign_key :authentications, :users
  end
end