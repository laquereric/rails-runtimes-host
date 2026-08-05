# frozen_string_literal: true

Rails.application.config.secret_key_base =
  ENV.fetch("SECRET_KEY_BASE") { "development-secret-key-base-for-local-demo-only-32b" }
