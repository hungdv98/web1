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

ActiveRecord::Schema.define(version: 20180725070706) do

  create_table "ckeditor_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "emojis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "emo"
    t.string "code"
    t.bigint "user_id"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_emojis_on_user_id"
  end

  create_table "histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "issue_id"
    t.string "type_issue"
    t.string "subject"
    t.text "description"
    t.string "status"
    t.string "priority"
    t.string "assignee"
    t.string "start_date"
    t.string "expired_date"
    t.string "estimate_time"
    t.string "percent_progress"
    t.string "parent_id"
    t.bigint "user_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_histories_on_issue_id"
    t.index ["project_id"], name: "index_histories_on_project_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "issue_relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "type_relationship"
    t.integer "issue_relation"
    t.integer "project_id"
    t.bigint "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_issue_relationships_on_issue_id"
  end

  create_table "issue_templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "type_template"
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_issue_templates_on_user_id"
  end

  create_table "issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "type_issue"
    t.string "subject"
    t.text "description"
    t.string "status"
    t.integer "priority"
    t.string "assignee"
    t.datetime "start_date"
    t.datetime "expired_date"
    t.string "estimate_time", default: "0.00"
    t.string "percent_progress"
    t.integer "parent_id"
    t.bigint "user_id"
    t.bigint "project_id"
    t.integer "issue_template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "pictures"
    t.index ["project_id"], name: "index_issues_on_project_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "img"
    t.bigint "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_pictures_on_issue_id"
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.string "status"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "user_projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_user_projects_on_project_id"
    t.index ["user_id", "project_id"], name: "index_user_projects_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_user_projects_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "login_name"
    t.string "last_name"
    t.string "first_name"
    t.string "email"
    t.string "password"
    t.integer "user_type", default: 1
    t.boolean "status", default: true
    t.boolean "email_notice", default: false
    t.boolean "hide_email", default: false
    t.datetime "last_login"
    t.string "provider", default: "none"
    t.string "uid", default: "none"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_foreign_key "emojis", "users"
  add_foreign_key "histories", "issues"
  add_foreign_key "histories", "projects"
  add_foreign_key "histories", "users"
  add_foreign_key "issue_relationships", "issues"
  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "users"
  add_foreign_key "pictures", "issues"
  add_foreign_key "projects", "users"
  add_foreign_key "user_projects", "projects"
  add_foreign_key "user_projects", "users"
end
