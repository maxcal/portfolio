class CreateSiteConfigurations < ActiveRecord::Migration
  def change
    create_table :site_configurations do |t|
      t.string :name
      t.integer :status
      t.string :site_title
      t.timestamps null: false
    end
    add_index :site_configurations, :name, unique: true
  end
end
