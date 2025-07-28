Rails.application.routes.draw do
  # Devise routes for Users
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  }

  # Devise routes for Admins
  devise_for :admins, 
    path: 'admin', 
    path_names: { sign_in: 'login', sign_out: 'logout'}, 
    controllers: {sessions: 'admin_panel/sessions'
  }

  # Admin namespace
  namespace :admin_panel do
    get 'dashboard', to: 'dashboard#index'
    root to: 'dashboard#index', as: :admin_root
  end

  # User namespace
  namespace :users do
    get 'dashboard', to: 'dashboard#index'
  end

  # Root redirections
  authenticated :admin do
    root to: 'admin_panel/dashboard#index', as: :admin_root
  end

  authenticated :user do
    root to: 'users/dashboard#index', as: :user_root
  end

  unauthenticated do
    root to: redirect('/login')
  end
end