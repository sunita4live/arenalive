  Rails.application.routes.draw do
    post '/rate' => 'rater#create', :as => 'rate'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    root to: 'home#index'

    devise_for :users, path: "", controllers: {registrations: "users/registrations", sessions: "users/sessions", confirmations: "users/confirmations", omniauth_callbacks: 'omniauth_callbacks'}, path_names: { sign_in: 'login', password: 'forgot', confirmation: 'confirm', unlock: 'unblock', sign_up: 'register', sign_out: 'signout', edit: 'dashboard'}

    # as :user do
    #   get '/' => 'devise/registrations#new', :as => :new_user_registration
    #   post 'register' => 'devise/registrations#create', :as => :user_registration
    #   get 'dashboard' => 'devise/registrations#edit', :as => :edit_user_registration
    #   patch 'dashboard' => 'devise/registrations#update', :as => :edit_user_registration
    #   put 'dashboard' => 'devise/registrations#update', :as => :edit_user_registration
    # end

    devise_scope :user do
      get "logout" => "users/sessions#destroy"
    end

    resources :grounds do
      collection do
        get 'search'
        post 'booking_initialize'
      end
      member do
        get 'ground_details'
      end
    end

    resources :bookings do
        collection do

        end
    end


    get 'profile' => 'home#profile'


    mount Commontator::Engine => '/commontator'
    #get 'search' => 'grounds#search'
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    # root 'welcome#index'

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

    # Example resource route with concerns:
    #   concern :toggleable do
    #     post 'toggle'
    #   end
    #   resources :posts, concerns: :toggleable
    #   resources :photos, concerns: :toggleable

    # Example resource route within a namespace:
    #   namespace :admin do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    #     resources :products
    #   end
  end
