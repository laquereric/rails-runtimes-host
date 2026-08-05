# frozen_string_literal: true

module Admin
  class DashboardController < BaseController
    def show
      @users = User.where(role: "member").includes(:installations).order(:display_name)
      @installations = Installation.includes(:user).order(created_at: :desc)
      @public_todos = PublicTodo.includes(installation: :user).order(host_committed_at: :desc)
      @summary = {
        users: @users.count,
        active_installations: Installation.where(status: "active").count,
        public_todos: PublicTodo.count
      }
    end
  end
end
