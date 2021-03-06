# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150606105014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string   "uid"
    t.integer  "user_id"
    t.string   "provider"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "authentications", ["provider", "uid"], name: "index_authentications_on_provider_and_uid", unique: true, using: :btree
  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "configurations", force: :cascade do |t|
    t.string   "name"
    t.boolean  "current"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "site_title"
    t.boolean  "registrations_open"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.text     "compiled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "author_id"
  end

  add_index "pages", ["author_id"], name: "index_pages_on_author_id", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", unique: true, using: :btree
  add_index "pages", ["title"], name: "index_pages_on_title", unique: true, using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "flickr_uid"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "square"
    t.string   "small"
    t.string   "medium"
    t.string   "original"
    t.datetime "date_taken"
  end

  add_index "photos", ["flickr_uid"], name: "index_photos_on_flickr_uid", using: :btree

  create_table "photos_photosets", id: false, force: :cascade do |t|
    t.integer "photo_id",    null: false
    t.integer "photoset_id", null: false
  end

  add_index "photos_photosets", ["photo_id", "photoset_id"], name: "index_photos_photosets_on_photo_id_and_photoset_id", using: :btree
  add_index "photos_photosets", ["photoset_id", "photo_id"], name: "index_photos_photosets_on_photoset_id_and_photo_id", using: :btree

  create_table "photosets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "flickr_uid"
    t.text     "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "primary_photo_id"
  end

  add_index "photosets", ["primary_photo_id"], name: "index_photosets_on_primary_photo_id", using: :btree
  add_index "photosets", ["user_id"], name: "index_photosets_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "site_configurations", force: :cascade do |t|
    t.string   "name"
    t.integer  "status"
    t.string   "site_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "site_configurations", ["name"], name: "index_site_configurations_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "flickr_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["flickr_uid"], name: "index_users_on_flickr_uid", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  add_foreign_key "authentications", "users"
  add_foreign_key "photosets", "users"
end
