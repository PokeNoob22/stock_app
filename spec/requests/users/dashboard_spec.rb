require 'rails_helper'

RSpec.describe "Users::Dashboard", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:user) do
    User.create!(
      email: "user1@example.com",
      password: "password",
      password_confirmation: "password",
      confirmed_at: Time.current
    )
  end

  describe "GET /users/dashboard" do
    context "when logged in" do
      before { sign_in user }

      it "returns http success" do
        get users_dashboard_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get users_dashboard_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /users/dashboard/deposit" do
    before do
      sign_in user
      user.update(balance: 100)
    end

    it "increases balance on valid amount" do
      post users_deposit_dashboard_path, params: { amount: 50 }
      expect(user.reload.balance).to eq(150)
    end

    it "does not change balance on invalid amount" do
      post users_deposit_dashboard_path, params: { amount: -10 }
      expect(user.reload.balance).to eq(100)
    end
  end

  describe "POST /users/dashboard/withdraw" do
    before do
      sign_in user
      user.update(balance: 100)
    end

    it "decreases balance on valid amount" do
      post users_withdraw_dashboard_path, params: { amount: 40 }
      expect(user.reload.balance).to eq(60)
    end

    it "does not decrease balance on excessive amount" do
      post users_withdraw_dashboard_path, params: { amount: 999 }
      expect(user.reload.balance).to eq(100)
    end
  end
end
