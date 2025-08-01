require 'rails_helper'

RSpec.describe "AdminPanel::Sessions", type: :request do
  let!(:admin) { Admin.create(email: "syd@example.com", password: "222222") }

  describe "POST /admin/login" do
    context "with valid credentials" do
      it "logs in the admin and redirects to dashboard" do
        post "/admin/login", params: {
          admin: {
            email: admin.email,
            password: "222222"
          }
        }

        expect(response).to redirect_to(admin_panel_dashboard_path)
        follow_redirect!
        expect(response.body).to include("Welcome", admin.email)
      end
    end

    context "with invalid credentials" do
      it "re-renders the login page with error" do
        post "/admin/login", params: {
          admin: {
            email: admin.email,
            password: "wrongpassword"
          }
        }

        expect(response.body).to include("Invalid Email or password")
      end
    end
  end

  describe "DELETE /admin/logout" do
    it "logs out the admin and redirects to root path" do
      sign_in admin
      delete "/admin/logout"
      expect(response).to redirect_to(root_path)
    end
  end
end
