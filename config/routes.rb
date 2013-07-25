require 'sidekiq/web'

Praiseme::Application.routes.draw do
  get "personal_news_feed/index"
  get "about" => "about#index"
  get "privacy_policy" => "about#privacy_policy"
  get "term_of_service" => "about#term_of_service"
  resources :stamp_suggestions

  get "comments/create"
  mount Sidekiq::Web, at: "/sidekiq"
  
  post "locations/update"
  resources :mypage, :only => :index
  resources :people, :only => :index
  resources :user_profiles, :only => [:index, :show] do
    get :edit, :on => :collection
    get :update, :on => :collection
    resources :followings, :only => :index
  end
  get "stamp_list" => "user_profiles#stamp_list"

  resources :followings, :only => [:create, :destroy]

  resources :news_feeds, :only => [:index] do
    get :get_score, :on => :member
  end

  resources :user_stamps
  resources :compliments do
    resources :comments, :only => [:create, :destroy]
  end
  resources :stamps

  get "main/index"

  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks", registrations: "users", sessions: "sessions"}
  
  resources :main, :only => [:index]
  root :to => "news_feeds#index"
  
  namespace :admin do
    root :to => "users#index"
    resources :default_trophy_images
    resources :users 
    resources :compliments 
    resources :stamps 
    resources :comments
  end

  namespace :api do
    resources :sessions
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root to: 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
