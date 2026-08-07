# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: LicenseRef-DataYoursSoftwareMine-1.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

class User < ApplicationRecord
  has_secure_password validations: false
  has_many :installations, dependent: :destroy

  validates :email, :email_downcase, :display_name, presence: true
  validates :email_downcase, uniqueness: true
  validates :role, inclusion: { in: %w[member admin] }
  validates :password, presence: true, length: { minimum: 8 }, if: -> { role == "admin" && password_digest.blank? }

  before_validation :normalize_email

  def admin?
    role == "admin"
  end

  private

  def normalize_email
    self.email = email.to_s.strip
    self.email_downcase = email.downcase
  end
end
