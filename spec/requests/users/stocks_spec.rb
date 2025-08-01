require 'rails_helper'

RSpec.describe "Users::Stocks", type: :request do
  let!(:user) { User.create(email: "trader@example.com", password: "password", official_trader: "Approved", balance: 1000.0, confirmed_at: Time.now) }

  before do
    sign_in user
  end

  describe "GET /users/stocks" do
    it "returns http success for approved trader" do
      allow(AlphaApi).to receive(:get_stock_price).and_return({
        "Meta Data" => { "2. Symbol" => "MSFT" },
        "Time Series (Daily)" => {
          "2025-07-31" => { "1. open" => "300.00" }
        }
      })

      get users_stocks_path
      expect(response).to have_http_status(:success)
    end

    it "redirects if API rate limit is hit" do
      allow(AlphaApi).to receive(:get_stock_price).and_return({ "Note" => "API limit exceeded" })

      get users_stocks_path
      expect(response).to redirect_to(users_dashboard_path)
      follow_redirect!
      expect(response.body).to include("Rate limit hit")
    end
  end

  describe "POST /users/stocks/buy" do
    it "successfully buys shares when balance is enough" do
      allow(AlphaApi).to receive(:get_stock_price).and_return({
        "Time Series (Daily)" => {
          "2025-07-31" => { "1. open" => "100.0" }
        }
      })

      post users_buy_users_stocks_path, params: { symbol: "AAPL", shares: 5 }

      expect(response).to redirect_to(users_stocks_path(symbol: "AAPL"))
      follow_redirect!
      expect(response.body).to include("You purchased 5 shares of AAPL")
    end

    it "fails to buy if shares is invalid" do
      post users_buy_users_stocks_path, params: { symbol: "AAPL", shares: 0 }
      expect(response).to redirect_to(users_stocks_path(symbol: "AAPL"))
      follow_redirect!
      expect(response.body).to include("Invalid share amount")
    end

    it "fails to buy if balance is insufficient" do
      allow(AlphaApi).to receive(:get_stock_price).and_return({
        "Time Series (Daily)" => {
          "2025-07-31" => { "1. open" => "1000.0" }
        }
      })

      post users_buy_users_stocks_path, params: { symbol: "AAPL", shares: 2 }

      expect(response).to redirect_to(users_stocks_path(symbol: "AAPL"))
      follow_redirect!
      expect(response.body).to include("Insufficient balance")
    end
  end

  describe "POST /users/stocks/sell" do
    before do
      user.stock_holdings.create(symbol: "AAPL", shares: 5)
    end

    it "successfully sells shares when holding is enough" do
      allow(AlphaApi).to receive(:get_stock_price).and_return({
        "Time Series (Daily)" => {
          "2025-07-31" => { "1. open" => "200.0" }
        }
      })

      post users_sell_users_stocks_path, params: { symbol: "AAPL", shares: 3 }

      expect(response).to redirect_to(users_stocks_path(symbol: "AAPL"))
      follow_redirect!
      expect(response.body).to include("Sold 3 shares of AAPL")
    end

    it "fails to sell when shares are too many" do
      post users_sell_users_stocks_path, params: { symbol: "AAPL", shares: 10 }
      expect(response).to redirect_to(users_stocks_path(symbol: "AAPL"))
      follow_redirect!
      expect(response.body).to include("Invalid number of shares to sell")
    end
  end
end
