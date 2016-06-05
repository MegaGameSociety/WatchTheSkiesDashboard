Rails.application.routes.draw do
  
  root 'splash#index'

  get 'dashboard' => 'games#dashboard', as: :dashboard
  # get 'games#dashboard', as :dashboard
  devise_for :users, :controllers => { :registrations => "users/registrations" }
  # get '/users' => 'games#dashboard'

  resources :incomes

  resources :tweets do 
    patch 'toggle_public', to: 'tweets#toggle_public', as: :toggle_public
  end
  post 'import_tweets', to: 'tweets#import_tweets', as: :import_tweets
  post 'publicize_all_tweets', to: 'tweets#publicize_all_tweets', as: :publicize_all_tweets

  post 'export_tweets', to: 'tweets#export_tweets', as: :export_tweets
  post 'hide_all_media', to: 'news_messages#hide_all_media', as: :hide_all_media

  resources :bonus_credits, except: [:show, :edit, :update]
  resources :terror_trackers
  resources :public_relations
  resources :messages
  resources :games
  resources :users
  resources :teams
  resources :splash

  resources :news_messages
  patch 'toggle_paper_content/:news_id', to: 'news_messages#toggle_paper_content', as: :toggle_paper_content
  patch 'toggle_paper_media/:news_id', to: 'news_messages#toggle_paper_media', as: :toggle_paper_media
  post 'direct_twitter_post', to: 'news_messages#direct_twitter_post', as: :direct_twitter_post

  get 'paper/:round' => 'news_messages#paper', as: :paper

  get 'news_players/index' => 'news_players#index'
  patch 'public_toggle_paper_content/:news_id', to: 'news_players#toggle_paper_content', as: :public_toggle_paper_content
  patch 'public_toggle_paper_media/:news_id', to: 'news_players#toggle_paper_media', as: :public_toggle_paper_media

  get 'un_dashboard' => 'public_relations#un_dashboard', as: :un_dashboard
  post 'un_dashboard' => 'public_relations#create_un_dashboard'
  get '/country_status/:country', to: 'public_relations#country_status', as: :country_pr_status
  get 'human_control' => 'games#human_control', as: :human_control
  post 'human_control' => 'games#create_human_pr'
  post 'messages/new' => 'messages#create'
  
  patch '/activity_update' => 'terror_trackers#update_activity', as: :activity_update

  # Administrative Controls
  get 'admin' =>'games#admin_control', :as =>'admin_control'
  patch '/update_den' => 'games#update_den', as: :den_tweet_update
  patch '/update_gnn' => 'games#update_gnn', as: :gnn_tweet_update
  patch '/update_sft' => 'games#update_sft', as: :sft_tweet_update

  post 'toggle_game_status', to: 'games#toggle_game_status', as: :toggle_game_status
  post 'toggle_alien_comms', to: 'games#toggle_alien_comms', as: :toggle_alien_comms
  post 'reset_game', to: 'games#reset', :as => 'reset_game'
  patch 'update_time/:id', to: 'games#update_time', as: :update_time
  patch 'alert_update', to: 'games#update_control_message', as: :alert_update
  patch 'rioters_update', to: 'games#update_rioters', as: :rioters_update
  patch 'round_update', to: 'games#update_round', as: :round_update

  get 'export_data/:round', to: 'games#export_data'

  # Api related routing
  namespace :api, :defaults => {:format => :json} do
    get 'games' => 'api#games'
    get 'dashboard_data' => 'api#dashboard'
    get 'dashboard_data/:game_id' => 'api#dashboard'
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
