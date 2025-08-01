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
      update_params = user_params.dup

    if update_params[:password].blank? && update_params[:password_confirmation].blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
    end

      # Skip reconfirmation if email changed
      @user.skip_reconfirmation! if @user.email != update_params[:email]

      if @user.update(update_params)
        redirect_to admin_panel_users_path, notice: "User updated successfully."
      else
        flash.now[:alert] = "Update failed: #{@user.errors.full_messages.join(', ')}"
        render :edit
      end
    end





    def destroy
      @user.destroy
      redirect_to admin_panel_users_path, notice: "User was successfully deleted."
    end

    def toggle_trader_status
      was_pending = @user.official_trader == "Pending"
      @user.official_trader = was_pending ? "Approved" : "Pending"

      if @user.save
        # Only send email if status changed from Pending to Approved
        UserMailer.approved_trader_email(@user).deliver_now if was_pending
        redirect_to admin_panel_users_path, notice: "Trader status updated."
      else
        redirect_to admin_panel_users_path, alert: "Failed to update trader status."
      end
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
