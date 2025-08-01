require 'rails_helper'

RSpec.describe "AdminPanel::Dashboard", type: :request do
  let(:admin) { Admin.create(email: "syd@example.com", password: "222222") }

  describe "GET /admin_panel/dashboard" do
    context "when not signed in" do
      it "redirects to the admin login page" do
        get "/admin_panel/dashboard"
        expect(response).to redirect_to("/admin/login")
      end
    end

    context "when signed in as admin" do
      before do
        sign_in admin
      end

      it "returns http success" do
        get "/admin_panel/dashboard"
        expect(response).to have_http_status(:success)
      end

      it "renders the welcome message with admin email" do
        get "/admin_panel/dashboard"
        expect(response.body).to include("Welcome, #{admin.email}")
      end
    end
  end
end

