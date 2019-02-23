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

ActiveRecord::Schema.define(version: 2019_02_23_022013) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "twilio_sid"
    t.string "twilio_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recording_total"
  end

  create_table "calls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration"
    t.integer "user_id"
    t.boolean "outbound"
    t.datetime "connected_at"
    t.datetime "hangup_at"
    t.string "to"
    t.string "from"
    t.string "network_id"
    t.text "transcription"
    t.index ["network_id"], name: "index_calls_on_network_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "outbound"
    t.string "to"
    t.string "from"
    t.string "network_id"
    t.string "content"
    t.index ["network_id"], name: "index_messages_on_network_id", unique: true
  end

  create_table "numbers", force: :cascade do |t|
    t.integer "account_id"
    t.string "network_id"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "config"
    t.string "whitelist", array: true
    t.datetime "forward_all_until"
    t.string "caller_id"
    t.integer "account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
