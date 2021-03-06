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

ActiveRecord::Schema.define(version: 20170607091525) do

  create_table "activities", force: :cascade do |t|
    t.string   "what"
    t.string   "url"
    t.boolean  "manual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bands", force: :cascade do |t|
    t.text     "tech_rider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "contactlocations", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "location_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "telephone"
    t.text     "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_types", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string   "subject"
    t.text     "text"
    t.integer  "gig_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "email_type_id"
    t.datetime "transferred_at"
  end

  add_index "emails", ["email_type_id"], name: "index_emails_on_email_type_id"
  add_index "emails", ["gig_id"], name: "index_emails_on_gig_id"

  create_table "fans", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "responsible_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "fans", ["responsible_id"], name: "index_fans_on_responsible_id"

  create_table "gigs", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "name"
    t.datetime "datetime"
    t.string   "link_forum"
    t.text     "vorhandenes_equipment"
    t.integer  "user_id"
    t.integer  "location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "website"
    t.boolean  "festival"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.decimal  "address_lat", precision: 12, scale: 10
    t.decimal  "address_lng", precision: 12, scale: 10
  end

  create_table "reminders", force: :cascade do |t|
    t.boolean  "done"
    t.date     "due"
    t.text     "text"
    t.integer  "gig_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reminders", ["gig_id"], name: "index_reminders_on_gig_id"

  create_table "status_values", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "statuses", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "gig_id"
    t.integer  "status_value_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.boolean  "admin"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "band_id"
    t.string   "instruments"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
