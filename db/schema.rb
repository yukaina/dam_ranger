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

ActiveRecord::Schema.define(version: 20160220113227) do

  create_table "dam_discharge_codes", force: :cascade do |t|
    t.integer  "dam_id"
    t.integer  "dam_cd"
    t.text     "dam_dischg_code"
    t.text     "dam_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "dam_discharge_codes", ["dam_dischg_code"], name: "index_dam_discharge_codes_on_dam_dischg_code"
  add_index "dam_discharge_codes", ["dam_id"], name: "index_dam_discharge_codes_on_dam_id"

  create_table "dam_purposes", force: :cascade do |t|
    t.integer  "dam_id"
    t.integer  "purpose_cd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dam_quantities", force: :cascade do |t|
    t.string   "observatory_sign_cd"
    t.string   "name"
    t.string   "dam_admin_type"
    t.string   "observatory_classification_cd"
    t.string   "river_system_cd"
    t.string   "jurisdiction_cd"
    t.string   "sub_jurisdiction_cd"
    t.string   "regional_bureau_cd"
    t.string   "office_cd"
    t.integer  "observatory_id"
    t.string   "local_governments_cd"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "dam_quantity_record_years", force: :cascade do |t|
    t.integer  "dam_quantity_id"
    t.string   "observatory_sign_cd"
    t.integer  "year"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "dam_quantity_record_years", ["dam_quantity_id"], name: "index_dam_quantity_record_years_on_dam_quantity_id"

  create_table "dam_quantity_records", force: :cascade do |t|
    t.integer  "dam_quantity_id"
    t.string   "observatory_sign_cd"
    t.datetime "observatory_at"
    t.date     "observatory_on"
    t.time     "observatory_time"
    t.float    "basin_avg_precipitation"
    t.integer  "pondage"
    t.float    "inflow_quantity"
    t.float    "discharge_quantity"
    t.float    "storing_water_rate"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "dam_quantity_records", ["dam_quantity_id"], name: "index_dam_quantity_records_on_dam_quantity_id"

  create_table "dam_types", id: false, force: :cascade do |t|
    t.integer "dam_id"
    t.integer "type_cd", null: false
  end

  create_table "dams", force: :cascade do |t|
    t.decimal "latitude",             precision: 18, scale: 15,             null: false
    t.decimal "longitude",            precision: 18, scale: 15,             null: false
    t.integer "dimension",                                      default: 2, null: false
    t.text    "name",                                                       null: false
    t.integer "dam_cd",                                                     null: false
    t.text    "river_system_name"
    t.text    "river_name"
    t.decimal "height",               precision: 18, scale: 15,             null: false
    t.decimal "width",                precision: 18, scale: 15,             null: false
    t.integer "volume",                                                     null: false
    t.integer "pondage",                                                    null: false
    t.integer "institution_cd",                                             null: false
    t.date    "completed_on",                                               null: false
    t.text    "address",                                                    null: false
    t.integer "location_accuracy_cd",                                       null: false
  end

  create_table "discharge_announcement_targeted_municipalities", force: :cascade do |t|
    t.integer  "discharge_announcement_id"
    t.integer  "targeted_municipality_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "discharge_announcement_targeted_municipalities", ["discharge_announcement_id"], name: "idx_discharge_announcement_targeted_municipalities_01"
  add_index "discharge_announcement_targeted_municipalities", ["targeted_municipality_id"], name: "idx_discharge_announcement_targeted_municipalities_02"

  create_table "discharge_announcements", force: :cascade do |t|
    t.text     "dam_dischg_code"
    t.text     "dam_name"
    t.text     "river_system_name"
    t.text     "river_name"
    t.text     "target_municipality"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "discharge_announcements", ["dam_dischg_code"], name: "index_discharge_announcements_on_dam_dischg_code"
  add_index "discharge_announcements", ["dam_name"], name: "index_discharge_announcements_on_dam_name"

  create_table "discharge_reports", force: :cascade do |t|
    t.text     "dam_dischg_code"
    t.datetime "report_at"
    t.integer  "report_no"
    t.integer  "discharge_announcement_id"
    t.text     "dam_name"
    t.text     "rever_system_name"
    t.text     "rever_name"
    t.text     "report_article"
    t.text     "publisher"
    t.text     "title"
    t.text     "document"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "discharge_reports", ["dam_dischg_code"], name: "index_discharge_reports_on_dam_dischg_code"
  add_index "discharge_reports", ["discharge_announcement_id"], name: "index_discharge_reports_on_discharge_announcement_id"

  create_table "targeted_municipalities", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "targeted_municipalities", ["name"], name: "uidx_targeted_municipalities_01", unique: true

end
