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

ActiveRecord::Schema.define(version: 20170320030841) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.integer  "default_id"
    t.boolean  "default",    default: false
  end

  create_table "implementations", force: :cascade do |t|
    t.text     "code"
    t.integer  "snippet_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "language_id"
    t.index ["snippet_id"], name: "index_implementations_on_snippet_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "user_id"
    t.boolean  "visible",           default: false
    t.integer  "default_id"
    t.boolean  "default",           default: false
  end

  create_table "quiz_snippets", force: :cascade do |t|
    t.text     "attempt"
    t.text     "answer"
    t.string   "title"
    t.integer  "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "snippet_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.integer  "language_id"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "complete",    default: false
    t.index ["language_id"], name: "index_quizzes_on_language_id"
  end

  create_table "snippets", force: :cascade do |t|
    t.string   "title"
    t.string   "runtime_complexity"
    t.string   "space_complexity"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "category_id"
    t.boolean  "active",             default: false
    t.integer  "user_id"
    t.integer  "default_id"
    t.boolean  "default",            default: false
    t.boolean  "modified",           default: false
    t.boolean  "visible",            default: false
    t.boolean  "update_available",   default: false
    t.index ["category_id"], name: "index_snippets_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
