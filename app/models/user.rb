class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :set_default_balance

  has_many :stock_holdings
  has_many :transactions

  private

  def set_default_balance
    self.balance = 0.0 if self.balance.nil?
  end
end
