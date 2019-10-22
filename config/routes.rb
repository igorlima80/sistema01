Rails.application.routes.draw do
  resources :members
  resources :leaders
  resources :events
  resources :payment_tests
  resources :menu_items
  
  
 
  resources :cities
  resources :states

  devise_for :users, path: "u"
  resources :users

  # token auth routes available at /api/auth
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'
    post 'cities/find'
    post 'cities/find_states'
    post 'cities/find_by_state'
    post 'special_periods/find_geolocation'   
    get 'settings/show'
    
        
    resources :leaders, only: [:show] do
      post :login, on: :collection
      post :update, on: :member
      get :members, on: :member  
    end
    
    
  end

  resources :home, only: [:index]

  devise_scope :user do
    authenticated :user do
      root to: 'home#index'
      mount Crono::Web, at: '/crono'
    end

    unauthenticated do
      root to: 'devise/sessions#new'
    end
  end

  post 'utils/zipcode'
  
end
