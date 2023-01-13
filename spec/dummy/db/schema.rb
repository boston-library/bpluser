# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_01_13_205206) do

  create_table "bpluser_folder_items", force: :cascade do |t|
    t.integer "folder_id"
    t.string "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["document_id"], name: "index_bpluser_folder_items_on_document_id"
    t.index ["folder_id"], name: "index_bpluser_folder_items_on_folder_id"
  end

  create_table "bpluser_folders", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "visibility"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'inet' for column 'current_sign_in_ip'

end
