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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110626165824) do

  create_table "hunts", :force => true do |t|
    t.integer  "map_id"
    t.integer  "user_id"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "last_recorded_at"
  end

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "map_id"
    t.string   "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.decimal  "lat"
    t.decimal  "lng"
    t.integer  "hunt_id"
    t.text     "body"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", :force => true do |t|
    t.decimal  "lat"
    t.decimal  "lng"
    t.integer  "hunt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "recorded_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "salt"
    t.string   "crypted_password"
    t.string   "persistence_token"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "single_access_token"
  end

  create_table "waypoints", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "map_id"
    t.decimal  "lat",        :precision => 15, :scale => 10
    t.decimal  "lng",        :precision => 15, :scale => 10
    t.decimal  "distance",   :precision => 10, :scale => 3
    t.decimal  "heading",    :precision => 10, :scale => 7
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
