class AdminPanel::SessionsController < Devise::SessionsController
  layout 'application'

  # Redirect to admin dashboard after login
  def after_sign_in_path_for(resource)
    admin_panel_dashboard_path
  end

  # Redirect to login page after logout
  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end
end
