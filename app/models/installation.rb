# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: LicenseRef-DataYoursSoftwareMine-1.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

class Installation < ApplicationRecord
  belongs_to :user
  has_many :public_todos, dependent: :destroy
  has_many :sync_receipts, dependent: :destroy
  has_many :source_sync_states, dependent: :destroy

  validates :client_instance_id, :application_name, :application_version,
            :manifest_digest, :sync_token_digest, presence: true
  validates :client_instance_id, uniqueness: true
  validates :status, inclusion: { in: %w[active revoked] }

  def active?
    status == "active"
  end

  def revoke!
    update!(status: "revoked")
  end
end
