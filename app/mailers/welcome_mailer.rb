class WelcomeMailer < ApplicationMailer
  default from: 'syd22tan@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to the Trading Stocks App')
  end
end