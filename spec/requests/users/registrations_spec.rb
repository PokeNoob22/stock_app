require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "POST /signup" do
    it "creates a new user and sends confirmation email" do
      expect {
        post user_registration_path, params: {
          user: {
            email: "newuser@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      }.to change(User, :count).by(1)

      user = User.last
      expect(user.email).to eq("newuser@example.com")
      expect(user.confirmed?).to be_falsey

      follow_redirect!
      expect(response.body).to include("A message with a confirmation link has been sent to your email address")
    end

    it "does not create user with invalid data" do
      expect {
        post user_registration_path, params: {
          user: {
            email: "", # invalid
            password: "short",
            password_confirmation: "nomatch"
          }
        }
      }.not_to change(User, :count)

      expect(response.body).to include("error", "Email", "Password").or include("prohibited this user from being saved")
    end
  end
end
