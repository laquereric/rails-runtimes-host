# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: LicenseRef-DataYoursSoftwareMine-1.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

Rails.application.config.filter_parameters += %i[
  passw email secret token _key crypt salt certificate otp ssn sync_token registration_code
]
