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

ActiveRecord::Schema[7.1].define(version: 2025_07_31_081019) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.date "date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "date"
    t.time "hour"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "galleries", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_galleries_on_user_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "date"
    t.time "hour"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_races_on_user_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "registerable_type", null: false
    t.bigint "registerable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bike_brand"
    t.integer "cylinder_capacity"
    t.string "stroke_type"
    t.string "race_number"
    t.index ["race_number", "registerable_id", "registerable_type"], name: "index_registrations_on_race_number_and_registerable", unique: true
    t.index ["registerable_type", "registerable_id"], name: "index_registrations_on_registerable"
    t.index ["user_id", "registerable_type", "registerable_id"], name: "idx_on_user_id_registerable_type_registerable_id_88e34dcfbb", unique: true
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "date"
    t.time "hour"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_trainings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name"
    t.string "role"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "post_code"
    t.string "town"
    t.string "country"
    t.string "phone_number"
    t.date "birth_date"
    t.string "license_code"
    t.string "license_number"
    t.boolean "club_member"
    t.string "club_name"
    t.string "club_affiliation_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["license_number"], name: "index_users_on_license_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articles", "users"
  add_foreign_key "events", "users"
  add_foreign_key "galleries", "users"
  add_foreign_key "races", "users"
  add_foreign_key "registrations", "users"
  add_foreign_key "trainings", "users"
end
