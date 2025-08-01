class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted? && !resource.confirmed?
        flash[:notice] = "A confirmation email has been sent to your address. Please confirm your email to log in."
      end
    end
  end
end
