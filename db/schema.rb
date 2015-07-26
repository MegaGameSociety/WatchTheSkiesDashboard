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

ActiveRecord::Schema.define(version: 20150726033705) do

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.integer  "round"
    t.string   "data"
    t.datetime "next_round"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "control_message"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "sender"
    t.string   "recipient"
    t.string   "content"
    t.integer  "round_number"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "public_relations", force: :cascade do |t|
    t.string   "country"
    t.string   "description"
    t.integer  "pr_amount"
    t.integer  "round"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
  end

  create_table "terror_trackers", force: :cascade do |t|
    t.string   "description"
    t.integer  "amount"
    t.integer  "round"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
