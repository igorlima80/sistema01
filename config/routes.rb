Rails.application.routes.draw do
  resources :visits
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
    
        
    resources :leaders, only: [:update, :show] do
      post :login, on: :collection
      get :members, on: :member  
      
    end

    resources :members, only: [:create, :show] do      
      post :find_unvisited, on: :collection      
      post :find, on: :collection
    end

    resources :visits, only: [:create, :show] do
      post :find, on: :collection
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
