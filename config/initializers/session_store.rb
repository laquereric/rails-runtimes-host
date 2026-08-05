# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
  key: "_rr_host_session",
  domain: nil,
  secure: Rails.env.production?,
  httponly: true,
  same_site: :lax
