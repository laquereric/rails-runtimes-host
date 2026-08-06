# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: Apache-2.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

require "digest"
require "json"

module PublicTodoHost
  module Server
    class Registration
      def initialize(payload:, registration_code:)
        @payload = payload.deep_stringify_keys
        @registration_code = registration_code.to_s
      end

      def call
        expected = ENV.fetch("HOST_REGISTRATION_CODE", "")
        if expected.empty? || !ActiveSupport::SecurityUtils.secure_compare(expected, @registration_code)
          return { ok: false, reason: :unauthorized, because: "invalid registration code", http: 401 }
        end

        client_instance_id = @payload["client_instance_id"].to_s
        owner = @payload["owner"] || {}
        application = @payload["application"] || {}
        manifest = @payload["manifest"] || {}

        if client_instance_id.empty? || owner["email"].to_s.empty?
          return { ok: false, reason: :invalid_request, because: "client_instance_id and owner.email required", http: 422 }
        end

        raw_token = Token.generate
        token_digest = Token.digest(raw_token)
        manifest_digest = Digest::SHA256.hexdigest(JSON.generate(manifest))

        user = nil
        installation = nil

        ActiveRecord::Base.transaction do
          user = User.find_or_initialize_by(email_downcase: owner["email"].to_s.strip.downcase)
          user.email = owner["email"].to_s.strip
          user.display_name = owner["display_name"].presence || user.email
          user.role = "member" if user.role.blank?
          user.save!

          installation = Installation.find_or_initialize_by(client_instance_id: client_instance_id)
          installation.user = user
          installation.application_name = application["name"].presence || "rails-runtimes-todo"
          installation.application_version = application["version"].presence || "0.1.0"
          installation.manifest_snapshot = manifest
          installation.manifest_digest = manifest_digest
          installation.sync_token_digest = token_digest
          installation.status = "active"
          installation.last_seen_at = Time.current
          installation.save!
        end

        {
          ok: true,
          protocol: "public-todo/v1",
          user: {
            id: user.id,
            email: user.email,
            display_name: user.display_name
          },
          installation: {
            id: installation.id,
            status: installation.status
          },
          credentials: {
            sync_token: raw_token
          },
          http: 201
        }
      end
    end
  end
end
