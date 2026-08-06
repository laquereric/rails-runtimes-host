# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: Apache-2.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

class HealthController < ApplicationController
  skip_forgery_protection

  def show
    render json: { ok: true, service: "rails-runtimes-host" }
  end
end
