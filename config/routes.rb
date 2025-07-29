Rails.application.routes.draw do
  # Updated Devise routes for users to use your custom registrations controller
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }

  # Devise routes for admins
  devise_for :admins,
    path: 'admin',
    path_names: { sign_in: 'login', sign_out: 'logout' },
    controllers: { sessions: 'admin_panel/sessions' }

  # Admin-only namespace
  namespace :admin_panel do
    get 'dashboard', to: 'dashboard#index'
    resources :users, except: [:show]
  end

  # User-only namespace
  namespace :users do
    get 'dashboard', to: 'dashboard#index'
  end

  # Authenticated roots
  authenticated :admin do
    root to: 'admin_panel/dashboard#index', as: :authenticated_admin_root
  end

  authenticated :user do
    root to: 'users/dashboard#index', as: :authenticated_user_root
  end

  # Default unauthenticated root
  unauthenticated do
    root to: 'home#index'
  end

  # Health and PWA routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
