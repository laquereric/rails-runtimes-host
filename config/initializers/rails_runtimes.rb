# frozen_string_literal: true

require "rails_runtimes"

manifest = RailsRuntimes::RuntimeManifest.define do
  id "public_todo_host"
  version "0.1.0"

  core do
    paths "app/services/public_todo_host/core"
  end

  server do
    paths "app/services/public_todo_host/server", "app/models", "app/controllers"
    capabilities :canonical_database, :credentials
    route mount_at: "/"
  end
end

registry = RailsRuntimes::Registry.new
result = registry.register(manifest)
raise result.fetch(:because) unless result.fetch(:ok)

Rails.application.config.x.rails_runtimes_registry = registry
