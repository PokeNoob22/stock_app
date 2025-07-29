module AdminPanel
  class UsersController < ApplicationController
    layout 'admin'
    before_action :authenticate_admin!
    before_action :set_user, only: [:edit, :update, :destroy, :toggle_trader_status]

    def index
      @users = User.all
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.official_trader = "Pending" # Default status
      if @user.save
        redirect_to admin_panel_users_path, notice: "User created successfully."
      else
        @users = User.all
        render :index, alert: "User creation failed."
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_panel_users_path, notice: "User updated successfully."
      else
        render :edit, alert: "Update failed."
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_panel_users_path, notice: "User was successfully deleted."
    end

    def toggle_trader_status
      @user.official_trader = @user.official_trader == "Approved" ? "Pending" : "Approved"
      @user.save
      redirect_to admin_panel_users_path, notice: "Trader status updated."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :official_trader)
    end
  end
end
