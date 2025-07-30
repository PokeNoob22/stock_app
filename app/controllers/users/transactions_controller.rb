module Users
  class TransactionsController < ApplicationController
    layout 'user'
    before_action :authenticate_user!
    before_action :ensure_trader_approved!

    def index
      @transactions = current_user.transactions.order(created_at: :desc)
    end

    private

    def ensure_trader_approved!
      unless current_user.official_trader == "Approved"
        redirect_to users_dashboard_path, alert: "You are not an approved trader yet."
      end
    end
  end
end
