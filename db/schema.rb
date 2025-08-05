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

ActiveRecord::Schema[8.0].define(version: 2025_08_05_070052) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "job_application_id", null: false
    t.string "attachment_type", null: false
    t.string "attachment_url", null: false
    t.string "version"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_attachments_on_deleted_at"
    t.index ["job_application_id"], name: "index_attachments_on_job_application_id"
  end

  create_table "interviews", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "job_application_id", null: false
    t.datetime "interview_date"
    t.string "location"
    t.string "interview_type", default: "online"
    t.text "notes"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_interviews_on_deleted_at"
    t.index ["job_application_id"], name: "index_interviews_on_job_application_id"
  end

  create_table "job_application_tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "job_application_id", null: false
    t.uuid "tag_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_job_application_tags_on_deleted_at"
    t.index ["job_application_id", "tag_id"], name: "index_job_application_tags_on_job_application_id_and_tag_id", unique: true
    t.index ["job_application_id"], name: "index_job_application_tags_on_job_application_id"
    t.index ["tag_id"], name: "index_job_application_tags_on_tag_id"
  end

  create_table "job_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "company_name"
    t.string "position_title"
    t.string "application_link"
    t.string "status", default: "draft"
    t.datetime "application_date"
    t.datetime "deadline_date"
    t.text "notes"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_job_applications_on_deleted_at"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_tags_on_deleted_at"
    t.index ["name"], name: "index_tags_on_name", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(deleted_at IS NULL)"
  end

  add_foreign_key "attachments", "job_applications"
  add_foreign_key "interviews", "job_applications"
  add_foreign_key "job_application_tags", "job_applications"
  add_foreign_key "job_application_tags", "tags"
  add_foreign_key "job_applications", "users"
end
