# frozen_string_literal: true
# Copyright 2026 CBI BUSINESS TRANSACTIONS, LLC
# SPDX-License-Identifier: LicenseRef-DataYoursSoftwareMine-1.0
# Part of RailsRuntimes -- https://github.com/laquereric/DataYoursSoftwareMine

module Admin
  class InstallationsController < BaseController
    def revoke
      installation = Installation.find(params[:id])
      installation.revoke!
      redirect_to admin_path, notice: "Installation revoked"
    end
  end
end
