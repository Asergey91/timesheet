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

ActiveRecord::Schema.define(version: 20170306173302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.integer  "client_id"
    t.integer  "project_id"
    t.datetime "created_at", default: '2019-03-20 16:11:35', null: false
    t.datetime "updated_at", default: '2019-03-20 16:11:36', null: false
  end

  create_table "assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at",  default: '2019-03-20 16:11:36', null: false
    t.datetime "updated_at",  default: '2019-03-20 16:11:36', null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", default: '2019-03-20 16:11:35', null: false
    t.datetime "updated_at", default: '2019-03-20 16:11:35', null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "client_id"
    t.datetime "created_at", default: '2019-03-20 16:11:35', null: false
    t.datetime "updated_at", default: '2019-03-20 16:11:35', null: false
  end

  create_table "references", force: :cascade do |t|
    t.string   "str_field"
    t.integer  "int_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "assignment_id"
    t.float    "hours"
    t.date     "date"
    t.text     "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "timers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.integer  "timer_status",       default: 0
    t.datetime "timer_paused_at"
    t.datetime "timer_started_at"
    t.integer  "timer_elapsed_time", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "handle"
    t.string   "email"
    t.string   "whatsapp"
    t.string   "tel"
    t.boolean  "is_admin"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "permission",         default: "default"
    t.integer  "timer_status",       default: 0
    t.datetime "timer_paused_at"
    t.datetime "timer_started_at"
    t.integer  "timer_elapsed_time", default: 0
    t.integer  "timer_activity",     default: 0
  end

end
