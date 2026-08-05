# frozen_string_literal: true

module Admin
  class InstallationsController < BaseController
    def revoke
      installation = Installation.find(params[:id])
      installation.revoke!
      redirect_to admin_path, notice: "Installation revoked"
    end
  end
end
