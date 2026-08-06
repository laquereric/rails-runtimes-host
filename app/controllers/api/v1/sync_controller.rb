# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: Apache-2.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

module Api
  module V1
    class SyncController < ApplicationController
      skip_forgery_protection

      def events
        installation = authenticate_installation!
        return if performed?

        raw = request.raw_post.to_s
        body = JSON.parse(raw.presence || "{}")
        result = PublicTodoHost::Server::EventApplier.new(
          installation: installation,
          body: body,
          raw_body_size: raw.bytesize
        ).call

        status = result.delete(:http) || 200
        render json: result, status: status
      rescue JSON::ParserError
        render json: { ok: false, reason: :invalid_json, because: "body must be JSON" }, status: 422
      end

      private

      def authenticate_installation!
        header = request.headers["Authorization"].to_s
        token = header.delete_prefix("Bearer ").strip
        if token.empty?
          render json: { ok: false, reason: :unauthorized, because: "missing bearer token" }, status: 401
          return nil
        end

        digest = PublicTodoHost::Server::Token.digest(token)
        installation = Installation.find_by(sync_token_digest: digest)
        unless installation
          render json: { ok: false, reason: :unauthorized, because: "invalid bearer token" }, status: 401
          return nil
        end
        unless installation.active?
          render json: { ok: false, reason: :forbidden, because: "installation revoked" }, status: 403
          return nil
        end
        installation
      end
    end
  end
end
