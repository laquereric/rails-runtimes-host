# frozen_string_literal: true

class Rack::Attack
  throttle("installations/ip", limit: 20, period: 60) do |req|
    req.ip if req.path == "/api/v1/installations" && req.post?
  end

  throttle("sync/ip", limit: 120, period: 60) do |req|
    req.ip if req.path == "/api/v1/sync/events" && req.post?
  end
end
