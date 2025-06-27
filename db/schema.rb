# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_22_063916) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "house_number", null: false
    t.string "street", null: false
    t.string "ward", null: false
    t.string "district", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "city_id"
    t.bigint "store_id"
    t.virtual "computed_address", type: :string, as: "(((((((house_number)::text || ' '::text) || (street)::text) || ', '::text) || (ward)::text) || ', '::text) || (district)::text)", stored: true
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["house_number", "street", "ward", "district"], name: "idx_on_house_number_street_ward_district_a2b67e137c", unique: true
    t.index ["store_id"], name: "index_addresses_on_store_id", unique: true
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "cities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_cities_on_code", unique: true
    t.index ["name"], name: "index_cities_on_name", unique: true
  end

  create_table "facilities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_facilities_on_name", unique: true
  end

  create_table "facilities_stores", primary_key: ["store_id", "facility_id"], force: :cascade do |t|
    t.bigint "store_id", null: false
    t.uuid "facility_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_facilities_stores_on_facility_id"
    t.index ["store_id"], name: "index_facilities_stores_on_store_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.uuid "order_id", null: false
    t.uuid "product_id", null: false
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.float "discount", default: 0.0
    t.integer "version", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "store_id", null: false
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.decimal "price", null: false
    t.string "thumbnail"
    t.string "image_urls", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "category_id", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "products_tags", force: :cascade do |t|
    t.uuid "product_id", null: false
    t.uuid "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_products_tags_on_product_id"
    t.index ["tag_id"], name: "index_products_tags_on_tag_id"
  end

  create_table "sizes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "icon", null: false
    t.decimal "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "product_id", null: false
    t.index ["product_id"], name: "index_sizes_on_product_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "image_urls", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stores_on_name", unique: true
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "toppings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "product_id", null: false
    t.index ["product_id"], name: "index_toppings_on_product_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "phone"
    t.string "address"
    t.datetime "verified_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "working_hours", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.time "open_hour", null: false
    t.time "close_hour", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id"
    t.string "day"
    t.index ["store_id"], name: "index_working_hours_on_store_id"
  end

  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "stores"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "facilities_stores", "facilities"
  add_foreign_key "facilities_stores", "stores"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "stores"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products_tags", "products"
  add_foreign_key "products_tags", "tags"
  add_foreign_key "sizes", "products"
  add_foreign_key "toppings", "products"
  add_foreign_key "working_hours", "stores"
end
