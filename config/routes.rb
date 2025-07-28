Rails.application.routes.draw do
  # Devise routes
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }
  devise_for :admins, path: 'admin', path_names: { sign_in: 'login', sign_out: 'logout' }

  # Admin-only namespace
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  # User-only namespace
  namespace :users do
    get 'dashboard', to: 'dashboard#index'
  end

  # Redirect based on role
  authenticated :admin do
    root to: 'admin/dashboard#index', as: :admin_root
  end

  authenticated :user do
    root to: 'users/dashboard#index', as: :user_root
  end

  # Fallback for not logged-in users
  unauthenticated do
    root to: redirect('/login')
  end

  # Health and PWA (unchanged)
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
