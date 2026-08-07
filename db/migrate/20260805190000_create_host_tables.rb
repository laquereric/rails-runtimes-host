# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: LicenseRef-DataYoursSoftwareMine-1.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

class CreateHostTables < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :string do |t|
      t.string :email, null: false
      t.string :email_downcase, null: false
      t.string :display_name, null: false
      t.string :role, null: false, default: "member"
      t.string :password_digest
      t.timestamps
    end
    add_index :users, :email_downcase, unique: true

    create_table :installations, id: :string do |t|
      t.string :user_id, null: false
      t.string :client_instance_id, null: false
      t.string :application_name, null: false
      t.string :application_version, null: false
      t.json :manifest_snapshot, null: false, default: {}
      t.string :manifest_digest, null: false
      t.string :sync_token_digest, null: false
      t.string :status, null: false, default: "active"
      t.datetime :last_seen_at
      t.timestamps
    end
    add_index :installations, :client_instance_id, unique: true

    create_table :sync_receipts, id: :string do |t|
      t.string :installation_id, null: false
      t.string :event_id, null: false
      t.string :status, null: false
      t.json :result, null: false, default: {}
      t.timestamps
    end
    add_index :sync_receipts, %i[installation_id event_id], unique: true

    create_table :source_sync_states, id: :string do |t|
      t.string :installation_id, null: false
      t.string :source_todo_id, null: false
      t.integer :last_sync_version, null: false, default: 0
      t.string :visibility_state
      t.datetime :last_source_updated_at
      t.timestamps
    end
    add_index :source_sync_states, %i[installation_id source_todo_id], unique: true

    create_table :public_todos, id: :string do |t|
      t.string :installation_id, null: false
      t.string :source_todo_id, null: false
      t.string :title, null: false
      t.boolean :completed, null: false, default: false
      t.datetime :source_updated_at
      t.datetime :host_committed_at
      t.timestamps
    end
    add_index :public_todos, %i[installation_id source_todo_id], unique: true
  end
end
