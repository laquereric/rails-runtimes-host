# frozen_string_literal: true

class HealthController < ApplicationController
  skip_forgery_protection

  def show
    render json: { ok: true, service: "rails-runtimes-host" }
  end
end
