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

ActiveRecord::Schema.define(version: 2016_10_29_132143) do

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "latitude", precision: 13, scale: 9, null: false
    t.decimal "longitude", precision: 13, scale: 9, null: false
    t.string "street1"
    t.string "street2"
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.text "tags"
    t.string "date"
    t.string "image_url", null: false
    t.string "thumbnail_url", null: false
    t.integer "width", null: false
    t.integer "height", null: false
    t.string "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.integer "angle"
    t.integer "location_id"
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
