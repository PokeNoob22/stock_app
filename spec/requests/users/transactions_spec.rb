require 'rails_helper'

RSpec.describe "Users::Transactions", type: :request do
  let(:user) { User.create!(email: "user@example.com", password: "password", official_trader: "Approved", confirmed_at: Time.now) }

  before do
    sign_in user
  end

  describe "GET /users/transactions" do
    it "shows the user's transactions when approved" do
      Transaction.create!(user: user, transaction_type: "buy", symbol: "AAPL", shares: 10, price: 100.0)
      Transaction.create!(user: user, transaction_type: "sell", symbol: "GOOG", shares: 5, price: 200.0)

      get users_transactions_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("AAPL")
      expect(response.body).to include("GOOG")
    end

    it "redirects unapproved traders to dashboard" do
      user.update!(official_trader: "Pending")

      get users_transactions_path

      expect(response).to redirect_to(users_dashboard_path)
      follow_redirect!
      expect(response.body).to include("You are not an approved trader yet.")
    end
  end
end
