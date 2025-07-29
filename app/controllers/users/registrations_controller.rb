class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        UserMailer.welcome_mail(resource).deliver_now
        flash[:notice] = "An email has been sent to welcome you to our app"
      end
    end
  end
end
