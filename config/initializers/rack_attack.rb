# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: LicenseRef-DataYoursSoftwareMine-1.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

class Rack::Attack
  throttle("installations/ip", limit: 20, period: 60) do |req|
    req.ip if req.path == "/api/v1/installations" && req.post?
  end

  throttle("sync/ip", limit: 120, period: 60) do |req|
    req.ip if req.path == "/api/v1/sync/events" && req.post?
  end
end
