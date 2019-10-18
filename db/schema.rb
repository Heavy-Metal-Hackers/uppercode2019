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

ActiveRecord::Schema.define(version: 20191018193200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"
  enable_extension "unaccent"

  create_table "addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "street_no"
    t.string   "street_no_addition"
    t.string   "zip_code"
    t.string   "city"
    t.decimal  "lat",                precision: 12, scale: 8
    t.decimal  "lng",                precision: 12, scale: 8
    t.boolean  "active"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.string   "pin"
    t.string   "schemaorg_id"
    t.integer  "parent_category_id"
    t.integer  "category_set_id"
    t.boolean  "active"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "categories", ["category_set_id"], name: "index_categories_on_category_set_id", using: :btree
  add_index "categories", ["key"], name: "index_categories_on_key", unique: true, using: :btree
  add_index "categories", ["parent_category_id"], name: "index_categories_on_parent_category_id", using: :btree

  create_table "category_sets", force: :cascade do |t|
    t.string   "category_type"
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "category_sets", ["category_type"], name: "index_category_sets_on_category_type", unique: true, using: :btree

  create_table "chat_nodes", force: :cascade do |t|
    t.integer  "chat_id"
    t.string   "message"
    t.integer  "direction"
    t.datetime "timestamp"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chat_nodes", ["chat_id"], name: "index_chat_nodes_on_chat_id", using: :btree

  create_table "chats", force: :cascade do |t|
    t.integer  "guest_id"
    t.datetime "started_at"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chats", ["guest_id"], name: "index_chats_on_guest_id", using: :btree

  create_table "geo_locations", force: :cascade do |t|
    t.string   "guid"
    t.integer  "local_id"
    t.string   "link"
    t.string   "description"
    t.string   "short_description"
    t.string   "name"
    t.string   "keywords"
    t.string   "image"
    t.string   "polygon"
    t.integer  "difficulty"
    t.integer  "length"
    t.integer  "duration"
    t.integer  "altitude_difference"
    t.boolean  "round_tour"
    t.boolean  "rest_stop"
    t.integer  "elev_min"
    t.integer  "elev_max"
    t.string   "elev_image"
    t.string   "gpx_link"
    t.boolean  "family_friendly"
    t.boolean  "barrier_free_info"
    t.integer  "address_id"
    t.integer  "contact_address_id"
    t.string   "tel"
    t.string   "email"
    t.string   "contact_email"
    t.string   "contact_link"
    t.boolean  "active"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "type"
  end

  add_index "geo_locations", ["address_id"], name: "index_geo_locations_on_address_id", using: :btree
  add_index "geo_locations", ["contact_address_id"], name: "index_geo_locations_on_contact_address_id", using: :btree
  add_index "geo_locations", ["guid"], name: "index_geo_locations_on_guid", using: :btree
  add_index "geo_locations", ["local_id"], name: "index_geo_locations_on_local_id", using: :btree

  create_table "guests", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trip_destinations", force: :cascade do |t|
    t.integer  "geo_location_id"
    t.integer  "trip_id"
    t.datetime "date"
    t.boolean  "active"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "trip_destinations", ["geo_location_id"], name: "index_trip_destinations_on_geo_location_id", using: :btree
  add_index "trip_destinations", ["trip_id"], name: "index_trip_destinations_on_trip_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.boolean  "active"
    t.integer  "guest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "trips", ["guest_id"], name: "index_trips_on_guest_id", using: :btree

end
