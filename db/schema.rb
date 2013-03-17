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

ActiveRecord::Schema.define(version: 20130312143823) do

  create_table "compliments", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "stamp_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "compliments", ["stamp_id"], name: "index_compliments_on_stamp_id"

  create_table "followings", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followings", ["followee_id"], name: "index_followings_on_followee_id"
  add_index "followings", ["follower_id"], name: "index_followings_on_follower_id"

  create_table "news_feeds", force: true do |t|
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.integer  "action"
    t.integer  "score",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_feeds", ["notifiable_id"], name: "index_news_feeds_on_notifiable_id"

  create_table "sns_connections", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stamps", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "used_count"
    t.boolean  "is_blocked"
    t.string   "image_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_news_feeds", force: true do |t|
    t.integer  "user_id"
    t.integer  "news_feed_id"
    t.boolean  "is_read",      default: false
    t.boolean  "score_taken",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_news_feeds", ["news_feed_id"], name: "index_user_news_feeds_on_news_feed_id"
  add_index "user_news_feeds", ["user_id"], name: "index_user_news_feeds_on_user_id"

  create_table "user_stamps", force: true do |t|
    t.integer  "stamp_id"
    t.integer  "user_id"
    t.integer  "exp",        default: 0
    t.integer  "level",      default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_stamps", ["stamp_id"], name: "index_user_stamps_on_stamp_id"
  add_index "user_stamps", ["user_id"], name: "index_user_stamps_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
