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

ActiveRecord::Schema.define(version: 20200901015305) do

  create_table "designers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.string   "lastname",   null: false
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "designs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "path_original_design", null: false
    t.string   "path_modified_design"
    t.integer  "price",                null: false
    t.integer  "project_id"
    t.integer  "designer_id"
    t.integer  "state_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["designer_id"], name: "index_designs_on_designer_id", using: :btree
    t.index ["project_id"], name: "index_designs_on_project_id", using: :btree
    t.index ["state_id"], name: "index_designs_on_state_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name_project", null: false
    t.string   "description",  null: false
    t.integer  "e_value",      null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "states", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name_state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "company",               null: false
    t.string   "email",                 null: false
    t.string   "password",              null: false
    t.string   "password_confirmation", null: false
    t.string   "token"
    t.string   "slug",                  null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "designs", "designers"
  add_foreign_key "designs", "projects"
  add_foreign_key "designs", "states"
  add_foreign_key "projects", "users"
end
