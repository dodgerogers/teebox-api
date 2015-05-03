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

ActiveRecord::Schema.define(version: 20150426220436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id"
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type", limit: 255
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "read",                       default: false
    t.text     "html"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "answers", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "votes_count",    default: 0
    t.boolean  "correct",        default: false
    t.integer  "comments_count", default: 0
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.text     "body"
    t.string   "tags",              limit: 255
    t.integer  "user_id"
    t.string   "cover_image",       limit: 255
    t.string   "state",             limit: 255, default: "draft"
    t.date     "published_at"
    t.integer  "impressions_count",             default: 0
    t.integer  "votes_count",                   default: 0
    t.integer  "comments_count",                default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "articles", ["state"], name: "index_articles_on_state", using: :btree
  add_index "articles", ["tags"], name: "index_articles_on_tags", using: :btree
  add_index "articles", ["title"], name: "index_articles_on_title", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "carrierwave_videos", force: :cascade do |t|
    t.string   "file",       limit: 255
    t.string   "screenshot", limit: 255
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "carrierwave_videos", ["user_id"], name: "index_carrierwave_videos_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
    t.integer  "user_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "votes_count",                  default: 0
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0
    t.integer  "attempts",               default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "impressions", force: :cascade do |t|
    t.integer "impressionable_id"
    t.string  "impressionable_type", limit: 255
    t.string  "ip_address",          limit: 255
  end

  create_table "playlists", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "video_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "playlists", ["question_id"], name: "index_playlists_on_question_id", using: :btree
  add_index "playlists", ["video_id"], name: "index_playlists_on_video_id", using: :btree

  create_table "points", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "pointable_id"
    t.string   "pointable_type", limit: 255
    t.integer  "value"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "points", ["pointable_id", "pointable_type"], name: "index_points_on_pointable_id_and_pointable_type", using: :btree
  add_index "points", ["user_id"], name: "index_points_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.text     "body"
    t.integer  "user_id"
    t.string   "youtube_url",       limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "votes_count",                   default: 0
    t.integer  "answers_count",                 default: 0
    t.boolean  "correct",                       default: false
    t.string   "tags",              limit: 255
    t.integer  "impressions_count",             default: 0
    t.integer  "comments_count",                default: 0
    t.integer  "videos_count",                  default: 0
  end

  add_index "questions", ["tags"], name: "index_questions_on_tags", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "questions"
    t.integer  "answers"
    t.integer  "users"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "answers_total"
    t.integer  "questions_total"
    t.integer  "users_total"
  end

  add_index "reports", ["answers"], name: "index_reports_on_answers", using: :btree
  add_index "reports", ["questions"], name: "index_reports_on_questions", using: :btree
  add_index "reports", ["users"], name: "index_reports_on_users", using: :btree

  create_table "socials", force: :cascade do |t|
    t.integer  "likes"
    t.integer  "followers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "tag_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "taggings", ["question_id"], name: "index_taggings_on_question_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "explanation"
    t.string   "updated_by",  limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",         null: false
    t.string   "encrypted_password",     limit: 255, default: "",         null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "username",               limit: 255
    t.integer  "reputation",                         default: 0
    t.string   "role",                   limit: 255, default: "standard"
    t.integer  "rank",                               default: 0
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.text     "preferences"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "file",       limit: 255
    t.integer  "user_id"
    t.string   "screenshot", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "job_id",     limit: 255
    t.string   "status",     limit: 255
    t.string   "duration",   limit: 255
    t.string   "location",   limit: 255
    t.string   "name",       limit: 255
  end

  add_index "videos", ["user_id"], name: "index_videos_on_user_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "value"
    t.integer  "votable_id"
    t.string   "votable_type", limit: 255
    t.integer  "user_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "points",                   default: 0
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree
  add_index "votes", ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type", using: :btree

end
