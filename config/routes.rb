Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, only: [:index, :show, :edit, :destroy, :update]

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/orders/new", to: 'orders#new'
  get "/orders/:id", to: 'orders#show'
  post "/orders", to: 'orders#create'

  get "/register", to: "users#new"
  post "/register", to: 'users#create'

  post "/users", to: "users#create"

  get "/login", to: 'sessions#new'
  post '/login', to: 'sessions#create'

  get "/logout", to: 'sessions#destroy'
  delete "/logout", to: 'sessions#destroy'

  namespace :default_user do
    get "/profile", to: 'profile#index'
    get "/profile/edit", to: 'profile#edit'
    patch "/profile", to: 'profile#update'
    get "/profile/orders", to: 'orders#index'
    get "/profile/orders/:order_id", to: 'orders#show'
    get "/cart", to: 'cart#show'
    get "/cancel", to: 'orders#update'
    patch "/profile/orders/:id", to: 'orders#update'
  end

  namespace :merchant do
    get '/', to: 'dashboard#index'
    get '/dashboard', to: 'dashboard#index'
    resources :merchant_items, path: 'items'
    get '/items/:item_id', to: 'merchant_items#edit'
    patch '/items/:item_id', to: 'merchant_items#update'
    resources :orders, only: [:index, :show, :update]
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/dashboard', to: 'dashboard#index'
    resources :orders, only: [:update, :show]
    resources :merchants do
      resources :merchant_items, path: 'items'
    end
    resources :users, only: [:index, :show]
    get '/users/:id/orders', to: 'orders#show'
  end
end
