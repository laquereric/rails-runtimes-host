# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: LicenseRef-DataYoursSoftwareMine-1.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

Rails.application.config.secret_key_base =
  ENV.fetch("SECRET_KEY_BASE") { "development-secret-key-base-for-local-demo-only-32b" }
