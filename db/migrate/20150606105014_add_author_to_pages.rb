class AddAuthorToPages < ActiveRecord::Migration
  def change
    add_reference :pages, :author, index: true
    add_foreign_key :pages, :users, column: :author_id
  end
end