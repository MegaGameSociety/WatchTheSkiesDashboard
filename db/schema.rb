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

ActiveRecord::Schema.define(version: 20160601083728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bonus_credits", force: :cascade do |t|
    t.boolean  "recurring"
    t.integer  "round"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.integer  "team_id"
  end

  add_index "bonus_credits", ["team_id"], name: "index_bonus_credits_on_team_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.integer  "round"
    t.boolean  "alien_comm"
    t.json     "data"
    t.datetime "next_round"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "control_message"
    t.string   "activity"
    t.string   "time_zone",       limit: 255, default: "UTC"
    t.string   "den",                         default: "DailyEarthWTS"
    t.string   "gnn",                         default: "GNNWTS"
    t.string   "sft",                         default: "SFTNews"
  end

  create_table "incomes", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "round"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.integer  "team_id"
  end

  add_index "incomes", ["game_id"], name: "index_incomes_on_game_id", using: :btree
  add_index "incomes", ["team_id"], name: "index_incomes_on_team_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "sender"
    t.string   "recipient"
    t.string   "content"
    t.integer  "round_number"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_messages", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.integer  "round"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "media_url"
    t.boolean  "visible_content"
    t.boolean  "visible_image"
    t.boolean  "media_landscape", default: false
  end

  create_table "public_relations", force: :cascade do |t|
    t.string   "description"
    t.integer  "pr_amount"
    t.integer  "round"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
    t.integer  "game_id"
    t.integer  "team_id"
  end

  add_index "public_relations", ["game_id"], name: "index_public_relations_on_game_id", using: :btree
  add_index "public_relations", ["team_id"], name: "index_public_relations_on_team_id", using: :btree

  create_table "team_roles", force: :cascade do |t|
    t.string   "role_name"
    t.string   "role_color"
    t.string   "role_permissions",  default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role_display_name"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "team_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terror_trackers", force: :cascade do |t|
    t.string   "description"
    t.integer  "amount"
    t.integer  "round"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "game_id"
  end

  add_index "terror_trackers", ["game_id"], name: "index_terror_trackers_on_game_id", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.string   "twitter_name"
    t.decimal  "tweet_id"
    t.string   "text"
    t.string   "media_url"
    t.boolean  "is_public"
    t.boolean  "is_published"
    t.datetime "tweet_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
  end

  add_index "tweets", ["game_id"], name: "index_tweets_on_game_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                              default: "",                           null: false
    t.string   "encrypted_password",                 default: "",                           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,                            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "time_zone",              limit: 255, default: "Pacific Time (US & Canada)"
    t.integer  "game_id"
    t.integer  "team_id"
    t.integer  "team_role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["game_id"], name: "index_users_on_game_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree
  add_index "users", ["team_role_id"], name: "index_users_on_team_role_id", using: :btree

  add_foreign_key "bonus_credits", "teams"
  add_foreign_key "incomes", "games"
  add_foreign_key "incomes", "teams"
  add_foreign_key "public_relations", "games"
  add_foreign_key "public_relations", "teams"
  add_foreign_key "terror_trackers", "games"
  add_foreign_key "tweets", "games"
  add_foreign_key "users", "games"
  add_foreign_key "users", "games"
  add_foreign_key "users", "team_roles"
end
