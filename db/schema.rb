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

ActiveRecord::Schema.define(version: 20130601172919) do

  create_table "compliments", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "stamp_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "compliments", ["stamp_id"], name: "index_compliments_on_stamp_id", using: :btree

  create_table "default_trophy_images", force: true do |t|
    t.string   "file"
    t.integer  "image_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followings", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followings", ["followee_id"], name: "index_followings_on_followee_id", using: :btree
  add_index "followings", ["follower_id"], name: "index_followings_on_follower_id", using: :btree

  create_table "friendships", force: true do |t|
    t.integer  "is_invited_by_id"
    t.integer  "has_invited_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["has_invited_id"], name: "index_friendships_on_has_invited_id", using: :btree
  add_index "friendships", ["is_invited_by_id"], name: "index_friendships_on_is_invited_by_id", using: :btree

  create_table "news_feeds", force: true do |t|
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.integer  "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_feeds", ["notifiable_id"], name: "index_news_feeds_on_notifiable_id", using: :btree

  create_table "sns_connections", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "url"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stamps", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "used_count"
    t.boolean  "is_blocked"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_trophy_image_id"
  end

  add_index "stamps", ["default_trophy_image_id"], name: "index_stamps_on_default_trophy_image_id", using: :btree

  create_table "user_news_feeds", force: true do |t|
    t.integer  "user_id"
    t.integer  "news_feed_id"
    t.boolean  "is_read",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_news_feeds", ["news_feed_id"], name: "index_user_news_feeds_on_news_feed_id", using: :btree
  add_index "user_news_feeds", ["user_id"], name: "index_user_news_feeds_on_user_id", using: :btree

  create_table "user_stamps", force: true do |t|
    t.integer  "stamp_id"
    t.integer  "user_id"
    t.integer  "score",         default: 10
    t.integer  "rank"
    t.integer  "previous_rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_stamps", ["stamp_id"], name: "index_user_stamps_on_stamp_id", using: :btree
  add_index "user_stamps", ["user_id"], name: "index_user_stamps_on_user_id", using: :btree

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
    t.float    "latitude"
    t.float    "longitude"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.text     "introduce"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "image"
    t.string   "facebook_image_url"
    t.integer  "status"
    t.string   "job"
    t.string   "school"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
