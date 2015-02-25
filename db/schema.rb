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

ActiveRecord::Schema.define(version: 20150223181650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'addresses', force: :cascade do |t|
    t.string   'original'
    t.string   'formatted'
    t.string   'zipcode'
    t.string   'neighborhood'
    t.float    'latitude'
    t.float    'longitude'
    t.text     'data'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.boolean  'geocoded',     default: false
  end

  add_index 'addresses', ['formatted'], name: 'index_addresses_on_formatted', using: :btree
  add_index 'addresses', ['latitude'], name: 'index_addresses_on_latitude', using: :btree
  add_index 'addresses', ['longitude'], name: 'index_addresses_on_longitude', using: :btree
  add_index 'addresses', ['neighborhood'], name: 'index_addresses_on_neighborhood', using: :btree
  add_index 'addresses', ['original'], name: 'index_addresses_on_original', using: :btree

  create_table 'categories', force: :cascade do |t|
    t.string   'name'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'companies', force: :cascade do |t|
    t.string   'name'
    t.text     'original_names'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'companies', ['name'], name: 'index_companies_on_name', using: :btree

  create_table 'map_types', force: :cascade do |t|
    t.string   'type'
    t.integer  'address_id'
    t.integer  'permit_id'
    t.integer  'parent_id'
    t.integer  'lft'
    t.integer  'rgt'
    t.integer  'depth'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'map_types', ['lft'], name: 'index_map_types_on_lft', using: :btree
  add_index 'map_types', ['parent_id'], name: 'index_map_types_on_parent_id', using: :btree
  add_index 'map_types', ['rgt'], name: 'index_map_types_on_rgt', using: :btree
  add_index 'map_types', ['type'], name: 'index_map_types_on_type', using: :btree

  create_table 'permits', force: :cascade do |t|
    t.integer  'event_ref'
    t.integer  'project_id'
    t.string   'event_name'
    t.string   'event_type'
    t.datetime 'event_start'
    t.datetime 'event_end'
    t.datetime 'entered_on'
    t.text     'original_location'
    t.string   'zip'
    t.string   'boro'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'permits', ['event_end'], name: 'index_permits_on_event_end', using: :btree
  add_index 'permits', ['event_start'], name: 'index_permits_on_event_start', using: :btree
  add_index 'permits', ['event_type'], name: 'index_permits_on_event_type', using: :btree
  add_index 'permits', ['project_id'], name: 'index_permits_on_project_id', using: :btree
  add_index 'permits', ['zip'], name: 'index_permits_on_zip', using: :btree

  create_table 'projects', force: :cascade do |t|
    t.integer  'city_ref'
    t.string   'title'
    t.integer  'company_id'
    t.integer  'category_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'projects', ['category_id'], name: 'index_projects_on_category_id', using: :btree
  add_index 'projects', ['city_ref'], name: 'index_projects_on_city_ref', using: :btree
  add_index 'projects', ['company_id'], name: 'index_projects_on_company_id', using: :btree
  add_index 'projects', ['title'], name: 'index_projects_on_title', using: :btree

end
