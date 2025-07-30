module Users
  class PortfolioController < ApplicationController
    layout 'user'
    before_action :authenticate_user!
    before_action :ensure_trader_approved!

    def index
      @holdings = current_user.stock_holdings
    end

    private

    def ensure_trader_approved!
      unless current_user.official_trader == "Approved"
        redirect_to users_dashboard_path, alert: "You are not an approved trader yet."
      end
    end
  end
end
