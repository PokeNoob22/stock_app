class UserMailer < ApplicationMailer
  def welcome_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Trading Stocks App!')
  end

  def approved_trader_email(user)
    @user = user
    mail(to: @user.email, subject: 'Approved trader')
  end
end
