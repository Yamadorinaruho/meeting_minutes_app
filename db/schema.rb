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

ActiveRecord::Schema[8.0].define(version: 2025_12_23_130140) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_departments_on_company_id"
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "department_id", null: false
    t.string "employee_number"
    t.string "name"
    t.string "email"
    t.integer "status"
    t.date "retired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.bigint "position_id"
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["position_id"], name: "index_employees_on_position_id"
  end

  create_table "meeting_minute_shares", force: :cascade do |t|
    t.bigint "meeting_minute_id", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_meeting_minute_shares_on_employee_id"
    t.index ["meeting_minute_id"], name: "index_meeting_minute_shares_on_meeting_minute_id"
  end

  create_table "meeting_minutes", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "employee_id", null: false
    t.string "title"
    t.datetime "meeting_date"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.text "transcription"
    t.integer "transcription_status", default: 0
    t.index ["company_id"], name: "index_meeting_minutes_on_company_id"
    t.index ["employee_id"], name: "index_meeting_minutes_on_employee_id"
  end

  create_table "positions", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name"
    t.integer "hourly_rate"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_positions_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.bigint "employee_id", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "departments", "companies"
  add_foreign_key "employees", "companies"
  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "positions"
  add_foreign_key "meeting_minute_shares", "employees"
  add_foreign_key "meeting_minute_shares", "meeting_minutes"
  add_foreign_key "meeting_minutes", "companies"
  add_foreign_key "meeting_minutes", "employees"
  add_foreign_key "positions", "companies"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "employees"
end
