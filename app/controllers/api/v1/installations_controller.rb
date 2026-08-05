# frozen_string_literal: true

module Api
  module V1
    class InstallationsController < ApplicationController
      skip_forgery_protection

      def create
        result = PublicTodoHost::Server::Registration.new(
          payload: JSON.parse(request.raw_post.presence || "{}"),
          registration_code: request.headers["X-Registration-Code"]
        ).call

        status = result.delete(:http) || (result[:ok] ? 201 : 422)
        render json: result, status: status
      rescue JSON::ParserError
        render json: { ok: false, reason: :invalid_json, because: "body must be JSON" }, status: 422
      end
    end
  end
end
