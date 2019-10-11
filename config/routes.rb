Rails.application.routes.draw do
  resources :members
  resources :leaders
  resources :events
  resources :payment_tests
  resources :menu_items
  resources :reserves do
    get 'perform_checkin', on: :member
    get 'perform_checkout', on: :member
  end
  
  
  resources :accommodations do
    resources :fees, shallow: true
    resources :services, shallow: true
    resources :special_periods, shallow: true
    resources :unavailabilities, shallow: true
    get 'toggle_available', on: :member
    get 'conveniences', on: :member
    get 'fees', on: :member
    get 'services', on: :member
    get 'special_periods', on: :member
    get 'unavailabilities', on: :member    
  end

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
    
    
    resources :accommodations, only: [:show] do
      post :find, on: :collection
      get :events, on: :member
    end
    resources :reserves, only: [:create, :show] do
      post :cancel, on: :member
    end  

    resources :leaders, only: [:show] do
      post :login, on: :collection
        
    end
    
    resources :ratings, only: [:create] 
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
