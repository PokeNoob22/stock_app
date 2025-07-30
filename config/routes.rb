Rails.application.routes.draw do
  # Devise routes
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }

  devise_for :admins,
    path: 'admin',
    path_names: { sign_in: 'login', sign_out: 'logout' },
    controllers: { sessions: 'admin_panel/sessions' }

  # Admin-only namespace 
  namespace :admin_panel do
    get 'dashboard', to: 'dashboard#index'
    get 'transactions', to: 'transactions#index'
    resources :users, except: [:show] do
      member do
        patch :toggle_trader_status
      end
    end
  end

  # User-only namespace
  namespace :users do
    get 'dashboard', to: 'dashboard#index'
    post 'dashboard/deposit', to: 'dashboard#deposit', as: 'deposit_dashboard'
    post 'dashboard/withdraw', to: 'dashboard#withdraw', as: 'withdraw_dashboard'
    get 'stocks', to: 'stocks#index'
    post 'stocks/buy', to: 'stocks#buy', as: 'buy_users_stocks'
    post 'stocks/sell', to: 'stocks#sell', as: 'sell_users_stocks'
    get 'portfolio', to: 'portfolio#index'
    get 'transactions', to: 'transactions#index'
  end



  # Authenticated roots
  authenticated :admin do
    root to: 'admin_panel/dashboard#index', as: :authenticated_admin_root
  end

  authenticated :user do
    root to: 'users/dashboard#index', as: :authenticated_user_root
  end

  # Default public landing page
  unauthenticated do
    root to: 'home#index'
  end

  # Health and PWA (unchanged)
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
