module Users
  class DashboardController < ApplicationController
    layout 'user' # This tells Rails to use app/views/layouts/user.html.erb
    before_action :authenticate_user! # This ensures only logged-in users can access


    def index
    end

    def deposit
      amount = params[:amount].to_f
      if amount > 0
        current_user.increment!(:balance, amount)
        redirect_to users_dashboard_path, notice: "Deposited $#{'%.2f' % amount} successfully."
      else
        redirect_to users_dashboard_path, alert: "Invalid amount."
      end
    end

    def withdraw
      amount = params[:amount].to_f
      if amount > 0 && amount <= current_user.balance
        current_user.decrement!(:balance, amount)
        redirect_to users_dashboard_path, notice: "Withdrew $#{'%.2f' % amount} successfully."
      else
        redirect_to users_dashboard_path, alert: "Invalid or insufficient balance."
      end
    end
  end
end
