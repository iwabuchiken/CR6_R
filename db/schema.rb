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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131011120916) do

  create_table "langs", :force => true do |t|
    t.string   "name"
    t.integer  "created_at_mill", :limit => 8, :default => 0, :null => false
    t.integer  "updated_at_mill", :limit => 8, :default => 0, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "links", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "memo"
    t.integer  "created_at_mill"
    t.integer  "updated_at_mill"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "passwd"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "settings", :force => true do |t|
    t.boolean  "mobile_view"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "texts", :force => true do |t|
    t.text     "text"
    t.string   "title"
    t.string   "word_ids"
    t.string   "url"
    t.integer  "genre_id",                     :default => 0, :null => false
    t.integer  "subgenre_id",                  :default => 0, :null => false
    t.integer  "lang_id",                      :default => 0, :null => false
    t.text     "memo"
    t.integer  "dbId",                         :default => 0, :null => false
    t.integer  "created_at_mill", :limit => 8, :default => 0, :null => false
    t.integer  "updated_at_mill", :limit => 8, :default => 0, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "word_lists", :force => true do |t|
    t.integer  "text_id",                      :default => 0, :null => false
    t.integer  "word_id",                      :default => 0, :null => false
    t.integer  "lang_id",                      :default => 0, :null => false
    t.integer  "db_id",                        :default => 0, :null => false
    t.integer  "created_at_mill", :limit => 8, :default => 0, :null => false
    t.integer  "updated_at_mill", :limit => 8, :default => 0, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "words", :force => true do |t|
    t.string   "w1"
    t.string   "w2"
    t.string   "w3"
    t.string   "text_ids"
    t.integer  "text_id",                      :default => 0, :null => false
    t.integer  "lang_id",                      :default => 0, :null => false
    t.integer  "dbId",                         :default => 0, :null => false
    t.integer  "created_at_mill", :limit => 8, :default => 0, :null => false
    t.integer  "updated_at_mill", :limit => 8, :default => 0, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

end
