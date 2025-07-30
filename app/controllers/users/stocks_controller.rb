module Users
  class StocksController < ApplicationController
    layout 'user'

    before_action :authenticate_user!
    before_action :ensure_trader_approved!

    def index
      symbol = params[:symbol] || "MSFT" # Default stock symbol
      data = AlphaApi.get_stock_price(symbol)

      time_series = data['Time Series (Daily)']
      @symbol = data.dig('Meta Data', '2. Symbol')

      if time_series
        @stock_price = time_series.values.first['1. open']
      else
        @stock_price = nil
      end
    end

    def buy
      shares = params[:shares].to_i
      symbol = params[:symbol].upcase
      data = AlphaApi.get_stock_price(symbol)
      price = data.dig("Time Series (Daily)")&.values&.first&.dig("1. open")&.to_f

      if price.nil?
        redirect_to users_stocks_path(symbol: symbol), alert: "Unable to retrieve stock price."
        return
      end

      total_cost = price * shares

      if shares <= 0
        redirect_to users_stocks_path(symbol: symbol), alert: "Invalid share amount."
      elsif current_user.balance >= total_cost
        current_user.decrement!(:balance, total_cost)

        holding = current_user.stock_holdings.find_or_initialize_by(symbol: symbol)
        holding.shares ||= 0
        holding.shares += shares
        holding.save!

        # Log transaction
        Transaction.create!(
          user: current_user,
          transaction_type: 'buy',
          symbol: symbol,
          shares: shares,
          price: price
        )

        redirect_to users_stocks_path(symbol: symbol), notice: "You purchased #{shares} shares of #{symbol} for $#{'%.2f' % total_cost}"
      else
        redirect_to users_stocks_path(symbol: symbol), alert: "Insufficient balance to complete purchase."
      end
    end

    def sell
      shares = params[:shares].to_i
      symbol = params[:symbol].upcase
      data = AlphaApi.get_stock_price(symbol)
      price = data.dig("Time Series (Daily)")&.values&.first&.dig("1. open")&.to_f

      if price.nil?
        redirect_to users_stocks_path(symbol: symbol), alert: "Unable to retrieve stock price."
        return
      end

      holding = current_user.stock_holdings.find_by(symbol: symbol)

      if holding.nil? || holding.shares < shares || shares <= 0
        redirect_to users_stocks_path(symbol: symbol), alert: "Invalid number of shares to sell."
        return
      end

      total_revenue = shares * price
      holding.decrement!(:shares, shares)
      holding.destroy if holding.shares == 0
      current_user.increment!(:balance, total_revenue)

      # Log transaction
      Transaction.create!(
        user: current_user,
        transaction_type: 'sell',
        symbol: symbol,
        shares: shares,
        price: price
      )

      redirect_to users_stocks_path(symbol: symbol), notice: "Sold #{shares} shares of #{symbol} for $#{'%.2f' % total_revenue}"
    end

    private

    def ensure_trader_approved!
      unless current_user.official_trader == "Approved"
        redirect_to users_dashboard_path, alert: "You are not an approved trader yet."
      end
    end
  end
end
