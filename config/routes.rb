# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: Apache-2.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

Rails.application.routes.draw do
  get "healthz", to: "health#show"

  namespace :api do
    namespace :v1 do
      post "installations", to: "installations#create"
      post "sync/events", to: "sync#events"
    end
  end

  get "admin/login", to: "admin/sessions#new"
  post "admin/session", to: "admin/sessions#create"
  delete "admin/session", to: "admin/sessions#destroy"
  get "admin", to: "admin/dashboard#show"
  post "admin/installations/:id/revoke", to: "admin/installations#revoke", as: :admin_revoke_installation

  root to: redirect("/admin")
end
