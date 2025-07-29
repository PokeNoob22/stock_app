module Users
  class DashboardController < ApplicationController
    layout 'user'                     # This tells Rails to use app/views/layouts/user.html.erb
    before_action :authenticate_user! # This ensures only logged-in users can access

    def index
    end
  end
end
