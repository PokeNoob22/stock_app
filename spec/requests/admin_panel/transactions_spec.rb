require 'rails_helper'

RSpec.describe "AdminPanel::Transactions", type: :request do
  let!(:admin) { Admin.create(email: "admin@example.com", password: "password") }
  let!(:user1) { User.create(email: "user1@example.com", password: "password", official_trader: "Approved") }
  let!(:transaction1) { Transaction.create(user: user1, symbol: "AAPL", transaction_type: "buy", shares: 5, price: 100.0) }

  describe "GET /admin_panel/transactions" do
    context "when admin is logged in" do
      before do
        sign_in admin
        get admin_panel_transactions_path
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "shows transaction details" do
        expect(response.body).to include("AAPL")
        expect(response.body).to include("Buy")
        expect(response.body).to include("100.0")
      end
    end

    context "when not logged in as admin" do
      it "redirects to admin login" do
        sign_out admin
        get admin_panel_transactions_path
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end
end
