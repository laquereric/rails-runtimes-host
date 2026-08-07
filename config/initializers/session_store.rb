# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: LicenseRef-DataYoursSoftwareMine-1.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

Rails.application.config.session_store :cookie_store,
  key: "_rr_host_session",
  domain: nil,
  secure: Rails.env.production?,
  httponly: true,
  same_site: :lax
