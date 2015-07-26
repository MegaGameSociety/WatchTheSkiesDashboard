Rails.application.routes.draw do
  
  root 'games#dashboard'

  resources :terror_trackers
  resources :public_relations
  resources :messages
  resources :games
  get 'un_dashboard' => 'public_relations#un_dashboard', as: :un_dashboard
  post 'un_dashboard' => 'public_relations#create_un_dashboard'
  get '/country_status/:country', to: 'public_relations#country_status', as: :country_pr_status
  get 'human_control' => 'games#human_control', as: :human_control
  post 'messages/new' => 'messages#create'
  
  # Administrative Controls
  get 'admin' =>'games#admin_control', :as =>'admin_control'
  post 'toggle_game_status', to: 'games#toggle_game_status', as: :toggle_game_status
  post 'reset_game', to: 'games#reset_game', :as => 'reset_game'
  patch 'update_time:id', to: 'games#update_time', as: :update_time
  patch 'alert_update', to: 'games#update_control_message', as: :alert_update

  # Api related routing
  namespace :api, :defaults => {:format => :json} do
    get 'dashboard_data' => 'api#dashboard'
  end

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
