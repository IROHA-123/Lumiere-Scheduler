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

ActiveRecord::Schema[7.1].define(version: 2025_05_15_000000) do
  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.date "work_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "required_number"
    t.time "start_time"
    t.time "end_time"
    t.string "location"
  end

  create_table "shift_assignments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_shift_assignments_on_project_id"
    t.index ["user_id"], name: "index_shift_assignments_on_user_id"
  end

  create_table "shift_requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_shift_requests_on_project_id"
    t.index ["user_id", "project_id"], name: "index_shift_requests_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_shift_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "name"
    t.string "employee_id"
    t.date "joined_on"
    t.string "work_style"
    t.integer "skill_level", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "shift_assignments", "projects"
  add_foreign_key "shift_assignments", "users"
  add_foreign_key "shift_requests", "projects"
  add_foreign_key "shift_requests", "users"
end
