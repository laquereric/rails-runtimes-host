# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :require_admin!

    private

    def require_admin!
      admin = User.find_by(id: session[:admin_user_id], role: "admin")
      return if admin

      redirect_to admin_login_path, alert: "Please sign in"
    end

    def current_admin
      @current_admin ||= User.find_by(id: session[:admin_user_id], role: "admin")
    end
    helper_method :current_admin
  end
end
