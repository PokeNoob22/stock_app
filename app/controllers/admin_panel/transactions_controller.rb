module AdminPanel
  class TransactionsController < ApplicationController
    layout 'admin'
    before_action :authenticate_admin!

    def index
      @transactions = Transaction.includes(:user).order(created_at: :desc)
    end
  end
end
