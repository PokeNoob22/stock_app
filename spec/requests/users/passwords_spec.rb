require 'rails_helper'

RSpec.describe "Users::Passwords", type: :request do
  let(:user) { User.create!(email: 'user@test.com', password: 'password123') }

  describe "POST #create" do
    it "sends reset email" do
      post user_password_path, params: { user: { email: user.email } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end