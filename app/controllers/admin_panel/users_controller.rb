module AdminPanel
  class UsersController < ApplicationController
    layout 'admin'
    before_action :authenticate_admin!
    before_action :set_user, only: [:edit, :update, :destroy]

    def index
      @users = User.all
      @user = User.new
    end

    def create
      @user = User.new(user_params)
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

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
