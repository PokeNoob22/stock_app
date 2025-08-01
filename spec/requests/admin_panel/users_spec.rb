require 'rails_helper'

RSpec.describe "AdminPanel::UsersController", type: :request do
  let!(:admin) { Admin.create!(email: "syd@example.com", password: "222222") }
  let!(:user) do 
    User.create!(
      email: "test_user@example.com",
      password: "123456",
      password_confirmation: "123456",
      official_trader: "Pending",
      confirmed_at: Time.now
    )
  end

  before do
    sign_in admin
  end

  describe "GET /admin_panel/users" do
    it "renders the index page successfully" do
      get admin_panel_users_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("User created successfully").or include("Edit")
    end
  end

  describe "PATCH /admin_panel/users/:id" do
    it "updates the user's email successfully" do
      patch admin_panel_user_path(user), params: {
        user: {
          email: "updated_user@example.com",
          password: "",
          password_confirmation: ""
        }
      }

      expect(response).to redirect_to(admin_panel_users_path)
      follow_redirect!
      expect(response.body).to include("User updated successfully")

      user.reload
      expect(user.email).to eq("updated_user@example.com")
    end
  end

  describe "PATCH /admin_panel/users/:id/toggle_trader_status" do
    it "toggles the trader status" do
      expect(user.official_trader).to eq("Pending")

      patch toggle_trader_status_admin_panel_user_path(user)
      expect(response).to redirect_to(admin_panel_users_path)

      user.reload
      expect(user.official_trader).to eq("Approved")
    end
  end
end
