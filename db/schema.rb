# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091125105941) do

  create_table "area_units", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "short_name", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_types", :force => true do |t|
    t.string   "name"
    t.string   "validator"
    t.string   "validation_error"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "contact_type_id", :null => false
    t.integer  "user_id",         :null => false
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["contact_type_id"], :name => "fk_contacts_contact_types"
  add_index "contacts", ["user_id"], :name => "fk_contacts_users"

  create_table "contacts_realties", :id => false, :force => true do |t|
    t.integer  "contact_id", :null => false
    t.integer  "realty_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts_realties", ["contact_id"], :name => "fk_contacts_realties_contacts"
  add_index "contacts_realties", ["realty_id"], :name => "fk_contacts_realties_realties"

  create_table "currencies", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "short_name", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "district_streets", :force => true do |t|
    t.integer  "district_id", :null => false
    t.string   "street",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "location_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
  end

  add_index "districts", ["location_id"], :name => "fk_districts_locations"

  create_table "irr_parsers", :force => true do |t|
    t.integer  "realty_field_id", :null => false
    t.string   "name",            :null => false
    t.string   "parser"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "list_field_values", :force => true do |t|
    t.integer  "realty_field_id",                                                                 :null => false
    t.string   "name",                                                                            :null => false
    t.integer  "field_value",                                                                     :null => false
    t.boolean  "default",                                                      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",          :limit => 10, :precision => 10, :scale => 0, :default => 0,     :null => false
  end

  add_index "list_field_values", ["realty_field_id"], :name => "fk_list_field_values_realty_fields"

  create_table "locations", :force => true do |t|
    t.string   "name",                          :null => false
    t.boolean  "is_place",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "realties", :force => true do |t|
    t.integer  "service_type_id",                                                                  :null => false
    t.integer  "realty_type_id",                                                                   :null => false
    t.string   "place"
    t.string   "street"
    t.string   "number"
    t.decimal  "price",                           :precision => 19, :scale => 2,                   :null => false
    t.integer  "currency_id",                                                                      :null => false
    t.string   "description",     :limit => 2000
    t.decimal  "total_area",                      :precision => 19, :scale => 2
    t.integer  "area_unit_id"
    t.boolean  "available",                                                      :default => true, :null => false
    t.float    "lat"
    t.float    "lng"
    t.boolean  "is_exact",                                                       :default => true, :null => false
    t.string   "irr_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                                                          :null => false
    t.integer  "district_id",                                                                      :null => false
    t.datetime "expire_at"
    t.decimal  "distance",                        :precision => 10, :scale => 3
    t.decimal  "predict_price",                   :precision => 19, :scale => 2
  end

  add_index "realties", ["area_unit_id"], :name => "fk_realty_area_units"
  add_index "realties", ["currency_id"], :name => "fk_realty_currencies"
  add_index "realties", ["realty_type_id"], :name => "fk_realty_realty_types"
  add_index "realties", ["service_type_id"], :name => "fk_realty_service_types"

  create_table "realty_field_groups", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "realty_field_settings", :force => true do |t|
    t.integer  "realty_type_id",                     :null => false
    t.integer  "realty_field_id",                    :null => false
    t.integer  "service_type_id"
    t.boolean  "required",        :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "realty_field_settings", ["realty_field_id"], :name => "fk_realty_field_settings_realty_fields"
  add_index "realty_field_settings", ["realty_type_id"], :name => "fk_realty_field_settings_realty_types"
  add_index "realty_field_settings", ["service_type_id"], :name => "fk_realty_field_settings_service_types"

  create_table "realty_field_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "realty_field_values", :force => true do |t|
    t.integer  "realty_id",       :null => false
    t.integer  "realty_field_id", :null => false
    t.string   "value",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "realty_field_values", ["realty_field_id"], :name => "fk_realty_field_values_realty_fields"
  add_index "realty_field_values", ["realty_id"], :name => "fk_realty_field_values_realties"

  create_table "realty_fields", :force => true do |t|
    t.string   "name",                                     :null => false
    t.integer  "realty_field_type_id",                     :null => false
    t.integer  "realty_field_group_id",                    :null => false
    t.boolean  "searchable",            :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "predict",               :default => false, :null => false
  end

  add_index "realty_fields", ["realty_field_group_id"], :name => "fk_realty_fields_realty_field_groups"
  add_index "realty_fields", ["realty_field_type_id"], :name => "fk_realty_fields_realty_field_types"

  create_table "realty_photos", :force => true do |t|
    t.integer  "realty_id",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "realty_photos", ["realty_id"], :name => "fk_realty_photos_realties"

  create_table "realty_purposes", :force => true do |t|
    t.string   "name",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "disabled",   :default => false, :null => false
  end

  create_table "realty_types", :force => true do |t|
    t.string   "name",              :null => false
    t.integer  "realty_purpose_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "realty_types", ["realty_purpose_id"], :name => "fk_realty_type_realty_purpose"

  create_table "service_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_requests", :force => true do |t|
    t.integer  "user_id",                                                          :null => false
    t.boolean  "active",                                         :default => true, :null => false
    t.integer  "service_type_id"
    t.integer  "location_id"
    t.integer  "district_id"
    t.integer  "realty_type_id"
    t.string   "place"
    t.string   "street"
    t.string   "number"
    t.decimal  "price_from",      :precision => 19, :scale => 2
    t.decimal  "price_to",        :precision => 19, :scale => 2
    t.decimal  "total_area_from", :precision => 19, :scale => 2
    t.decimal  "total_area_to",   :precision => 19, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.boolean  "is_admin",                                :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
