# frozen_string_literal: true

module Admin
  class SessionsController < ApplicationController
    def new
    end

    def create
      user = User.find_by(email_downcase: params[:email].to_s.strip.downcase, role: "admin")
      if user&.authenticate(params[:password].to_s)
        session[:admin_user_id] = user.id
        redirect_to admin_path
      else
        flash.now[:alert] = "Invalid credentials"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      reset_session
      redirect_to admin_login_path
    end
  end
end
