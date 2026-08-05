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

ActiveRecord::Schema[8.0].define(version: 2026_08_05_190000) do
  create_table "installations", id: :string, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "client_instance_id", null: false
    t.string "application_name", null: false
    t.string "application_version", null: false
    t.json "manifest_snapshot", default: {}, null: false
    t.string "manifest_digest", null: false
    t.string "sync_token_digest", null: false
    t.string "status", default: "active", null: false
    t.datetime "last_seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_instance_id"], name: "index_installations_on_client_instance_id", unique: true
  end

  create_table "public_todos", id: :string, force: :cascade do |t|
    t.string "installation_id", null: false
    t.string "source_todo_id", null: false
    t.string "title", null: false
    t.boolean "completed", default: false, null: false
    t.datetime "source_updated_at"
    t.datetime "host_committed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["installation_id", "source_todo_id"], name: "index_public_todos_on_installation_id_and_source_todo_id", unique: true
  end

  create_table "source_sync_states", id: :string, force: :cascade do |t|
    t.string "installation_id", null: false
    t.string "source_todo_id", null: false
    t.integer "last_sync_version", default: 0, null: false
    t.string "visibility_state"
    t.datetime "last_source_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["installation_id", "source_todo_id"], name: "index_source_sync_states_on_installation_id_and_source_todo_id", unique: true
  end

  create_table "sync_receipts", id: :string, force: :cascade do |t|
    t.string "installation_id", null: false
    t.string "event_id", null: false
    t.string "status", null: false
    t.json "result", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["installation_id", "event_id"], name: "index_sync_receipts_on_installation_id_and_event_id", unique: true
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "email", null: false
    t.string "email_downcase", null: false
    t.string "display_name", null: false
    t.string "role", default: "member", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_downcase"], name: "index_users_on_email_downcase", unique: true
  end
end
