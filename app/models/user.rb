class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  before_create :set_default_balance

  has_many :stock_holdings, dependent: :destroy
  has_many :transactions, dependent: :destroy

  private

  def set_default_balance
    self.balance = 0.0 if self.balance.nil?
  end

  def send_welcome_email
    UserMailer.welcome_mail(self).deliver_later
  end
end
