class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.text :compiled
      t.timestamps null: false
    end
    add_index :pages, :title, unique: true
    add_index :pages, :slug, unique: true
  end
end
