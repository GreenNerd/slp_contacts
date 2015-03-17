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

ActiveRecord::Schema.define(version: 20150317022924) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "namespaces", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "namespace_id"
  end

  add_index "organizations", ["namespace_id"], name: "index_organizations_on_namespace_id", using: :btree
  add_index "organizations", ["parent_id"], name: "index_organizations_on_parent_id", using: :btree

  create_table "slp_contacts_custom_fields", force: :cascade do |t|
    t.integer  "namespace_id"
    t.string   "name"
    t.string   "type"
    t.string   "field_type"
    t.string   "possible_values"
    t.boolean  "is_required"
    t.boolean  "is_unique"
    t.boolean  "editable"
    t.boolean  "visible"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "slp_contacts_favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "slp_contacts_favorites", ["contact_id"], name: "index_slp_contacts_favorites_on_contact_id", using: :btree
  add_index "slp_contacts_favorites", ["user_id"], name: "index_slp_contacts_favorites_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_organizations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "user_organizations", ["organization_id"], name: "index_user_organizations_on_organization_id", using: :btree
  add_index "user_organizations", ["user_id"], name: "index_user_organizations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "identifier"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "remember_token"
    t.string   "headimgurl"
    t.integer  "namespace_id"
  end

  add_index "users", ["namespace_id"], name: "index_users_on_namespace_id", using: :btree

  add_foreign_key "organizations", "namespaces"
  add_foreign_key "slp_contacts_favorites", "users"
  add_foreign_key "slp_contacts_favorites", "users", column: "contact_id"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "users", column: "taggable_id"
  add_foreign_key "user_organizations", "organizations"
  add_foreign_key "user_organizations", "users"
  add_foreign_key "users", "namespaces"
end
