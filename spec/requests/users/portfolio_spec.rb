require 'rails_helper'

RSpec.describe "Users::Portfolio", type: :request do
  let!(:user) { User.create!(email: "user1@example.com", password: "password", official_trader: status, confirmed_at: Time.current) }

  describe "GET /users/portfolio" do
    context "when user is logged in and approved" do
      let(:status) { "Approved" }

      before do
        sign_in user
        get users_portfolio_path
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is logged in and not approved" do
      let(:status) { "Pending" }

      before do
        sign_in user
        get users_portfolio_path
      end

      it "redirects to users dashboard with alert" do
        expect(response).to redirect_to(users_dashboard_path)
        follow_redirect!
        expect(response.body).to include("You are not an approved trader yet.")
      end
    end

    context "when user is not logged in" do
      let(:status) { "Approved" }

      it "redirects to login page" do
        get users_portfolio_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
