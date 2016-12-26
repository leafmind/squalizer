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

ActiveRecord::Schema.define(version: 20161229073716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "square_id"
    t.index ["square_id"], name: "index_locations_on_square_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_locations_on_user_id", using: :btree
  end

  create_table "reports", force: :cascade do |t|
    t.string   "state"
    t.integer  "user_id"
    t.text     "statistics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "average"
    t.index ["user_id"], name: "index_reports_on_user_id", using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "location_id"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "idempotency_key"
    t.integer  "amount"
    t.string   "currency"
    t.datetime "square_created_at", null: false
    t.string   "square_id"
    t.index ["idempotency_key"], name: "index_transactions_on_idempotency_key", unique: true, using: :btree
    t.index ["location_id", "square_id"], name: "index_transactions_on_location_id_and_square_id", unique: true, using: :btree
    t.index ["location_id"], name: "index_transactions_on_location_id", using: :btree
    t.index ["user_id"], name: "index_transactions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "uid"
    t.string   "provider"
    t.string   "token"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "sandbox",    default: false
    t.string   "state"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
    t.index ["provider"], name: "index_users_on_provider", using: :btree
    t.index ["uid"], name: "index_users_on_uid", using: :btree
  end

  add_foreign_key "locations", "users"
  add_foreign_key "reports", "users"
  add_foreign_key "transactions", "locations"
  add_foreign_key "transactions", "users"
end
