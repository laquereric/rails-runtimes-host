# frozen_string_literal: true

module PublicTodoHost
  module Server
    class EventApplier
      MAX_EVENTS = 100
      MAX_BODY = 256 * 1024

      def initialize(installation:, body:, raw_body_size:)
        @installation = installation
        @body = body.deep_stringify_keys
        @raw_body_size = raw_body_size
      end

      def call
        if @raw_body_size > MAX_BODY
          return { ok: false, reason: :payload_too_large, because: "body exceeds 256 KiB", http: 413 }
        end

        events = Array(@body["events"])
        if events.size > MAX_EVENTS
          return { ok: false, reason: :too_many_events, because: "max #{MAX_EVENTS} events", http: 422 }
        end

        request_id = @body["request_id"]
        accepted = []
        rejected = []

        events.each do |raw_event|
          outcome = apply_one(raw_event)
          if outcome[:status] == "rejected"
            rejected << outcome
          else
            accepted << outcome
          end
        end

        @installation.update!(last_seen_at: Time.current)

        {
          ok: true,
          request_id: request_id,
          accepted: accepted,
          rejected: rejected,
          http: 200
        }
      end

      private

      def apply_one(raw_event)
        validated = PublicTodoHost::Core::EventValidator.validate(raw_event)
        unless validated[:ok]
          return {
            event_id: raw_event.is_a?(Hash) ? (raw_event["event_id"] || raw_event[:event_id]) : nil,
            status: "rejected",
            reason: validated[:reason],
            because: validated[:because]
          }
        end

        event = validated[:event]
        event_id = validated[:event_id]
        version = validated[:sync_version]
        source_todo_id = validated[:source_todo_id]

        existing = SyncReceipt.find_by(installation_id: @installation.id, event_id: event_id)
        if existing
          result = existing.result.deep_symbolize_keys
          return result.merge(event_id: event_id, status: existing.status)
        end

        ActiveRecord::Base.transaction do
          state = SourceSyncState.lock.find_or_initialize_by(
            installation_id: @installation.id,
            source_todo_id: source_todo_id
          )
          state.last_sync_version ||= 0

          if version < state.last_sync_version
            result = {
              event_id: event_id,
              status: "rejected",
              reason: :stale_source_version,
              because: "sync_version #{version} < cursor #{state.last_sync_version}"
            }
            SyncReceipt.create!(installation: @installation, event_id: event_id, status: "rejected", result: result)
            return result
          end

          if version == state.last_sync_version && state.last_sync_version.positive?
            result = {
              event_id: event_id,
              status: "applied",
              reason: :duplicate_version,
              public_todo_id: PublicTodo.find_by(installation: @installation, source_todo_id: source_todo_id)&.id
            }
            SyncReceipt.create!(installation: @installation, event_id: event_id, status: "applied", result: result)
            return result
          end

          if version > state.last_sync_version + 1 && state.last_sync_version.positive?
            result = {
              event_id: event_id,
              status: "rejected",
              reason: :out_of_order_source_version,
              because: "expected #{state.last_sync_version + 1}, got #{version}"
            }
            SyncReceipt.create!(installation: @installation, event_id: event_id, status: "rejected", result: result)
            return result
          end

          # version == last + 1, or first event (cursor 0)
          public_todo_id = nil
          case event["event_type"]
          when "todo.publish"
            data = event["data"] || {}
            pt = PublicTodo.find_or_initialize_by(
              installation_id: @installation.id,
              source_todo_id: source_todo_id
            )
            pt.title = data["title"].to_s
            pt.completed = !!data["completed"]
            pt.source_updated_at = Time.iso8601(data["source_updated_at"]) rescue Time.current
            pt.host_committed_at = Time.current
            pt.save!
            public_todo_id = pt.id
            state.visibility_state = "public"
          when "todo.withdraw"
            PublicTodo.where(installation_id: @installation.id, source_todo_id: source_todo_id).delete_all
            state.visibility_state = "withdrawn"
          end

          state.last_sync_version = version
          state.last_source_updated_at = Time.current
          state.save!

          result = {
            event_id: event_id,
            status: "applied",
            public_todo_id: public_todo_id
          }
          SyncReceipt.create!(installation: @installation, event_id: event_id, status: "applied", result: result)
          result
        end
      end
    end
  end
end
