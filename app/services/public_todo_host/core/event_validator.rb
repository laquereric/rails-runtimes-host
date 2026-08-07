# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: LicenseRef-DataYoursSoftwareMine-1.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

module PublicTodoHost
  module Core
    module EventValidator
      UUID = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
      EVENT_TYPES = %w[todo.publish todo.withdraw].freeze
      MAX_TITLE = 200

      module_function

      def validate(event)
        event = event.deep_stringify_keys
        errors = []

        event_id = event["event_id"].to_s
        errors << "event_id must be a UUID" unless event_id.match?(UUID)
        errors << "event_type invalid" unless EVENT_TYPES.include?(event["event_type"].to_s)

        source = event["source"] || {}
        todo_id = source["todo_id"].to_s
        errors << "source.todo_id must be a UUID" unless todo_id.match?(UUID)

        version = source["sync_version"]
        begin
          version = Integer(version)
          errors << "sync_version must be positive" if version < 1
        rescue ArgumentError, TypeError
          errors << "sync_version must be an integer"
          version = nil
        end

        data = event["data"] || {}
        if event["event_type"].to_s == "todo.publish"
          title = data["title"].to_s.strip
          errors << "title required" if title.empty?
          errors << "title too long" if title.length > MAX_TITLE
        end

        return { ok: false, reason: :invalid_event, because: errors.join("; "), errors: errors } if errors.any?

        { ok: true, event: event, event_id: event_id, sync_version: version, source_todo_id: todo_id }
      end
    end
  end
end
