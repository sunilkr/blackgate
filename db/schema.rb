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

ActiveRecord::Schema.define(version: 20141105112211) do

  create_table "cnc_traffics", force: true do |t|
    t.integer  "sample_id"
    t.integer  "command_and_control_id"
    t.date     "accessedOn"
    t.string   "url"
    t.string   "request"
    t.string   "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  add_index "cnc_traffics", ["command_and_control_id"], name: "index_cnc_traffics_on_command_and_control_id"
  add_index "cnc_traffics", ["sample_id"], name: "index_cnc_traffics_on_sample_id"

  create_table "command_and_controls", force: true do |t|
    t.string   "domain"
    t.string   "ip"
    t.string   "protocol"
    t.integer  "port"
    t.date     "first_access"
    t.date     "last_access"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "containers", force: true do |t|
    t.integer "sample_id"
    t.integer "container_id"
  end

  add_index "containers", ["sample_id"], name: "index_containers_on_sample_id"

  create_table "incident_reorts", force: true do |t|
    t.integer "incident_id"
    t.integer "report_id"
  end

  add_index "incident_reorts", ["incident_id"], name: "index_incident_reorts_on_incident_id"
  add_index "incident_reorts", ["report_id"], name: "index_incident_reorts_on_report_id"

  create_table "incidents", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.date     "reportedOn"
    t.string   "reportedBy"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: true do |t|
    t.string   "sha1"
    t.string   "title"
    t.date     "createdOn"
    t.date     "updatedOn"
    t.integer  "reportable_id"
    t.string   "reportable_type"
    t.string   "mimeType"
    t.integer  "size"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sample_data", force: true do |t|
    t.integer  "sample_id"
    t.string   "sha1"
    t.string   "md5"
    t.string   "ssdeep"
    t.string   "mimeType"
    t.integer  "size"
    t.string   "key"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sample_data", ["sample_id"], name: "index_sample_data_on_sample_id"

  create_table "sample_names", force: true do |t|
    t.integer  "sample_id"
    t.integer  "incident_id"
    t.string   "name"
    t.date     "reportedOn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sample_names", ["incident_id"], name: "index_sample_names_on_incident_id"
  add_index "sample_names", ["sample_id"], name: "index_sample_names_on_sample_id"

  create_table "sample_reorts", force: true do |t|
    t.integer "sample_id"
    t.integer "report_id"
  end

  add_index "sample_reorts", ["report_id"], name: "index_sample_reorts_on_report_id"
  add_index "sample_reorts", ["sample_id"], name: "index_sample_reorts_on_sample_id"

  create_table "samples", force: true do |t|
    t.date     "reportedOn"
    t.string   "group"
    t.string   "categories"
    t.string   "status"
    t.date     "analyzedOn"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
