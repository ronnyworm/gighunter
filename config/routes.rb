Rails.application.routes.draw do
  devise_for :users, :skip => :registrations
  resources :gigs, except: [:show] do
    member do
      get 'duplicate'
    end
  end
  
  post 'band/edit' => 'gigs#edit_band'

  get 'settings' => 'gigs#settings'
  post 'settings' => 'gigs#post_settings'
  post 'settings/edit_status' => 'gigs#edit_status'
  post 'settings/edit_template' => 'gigs#edit_template'

  match 'dringende_massnahmen' => 'gigs#apply', :as => :dringende_massnahmen, :via => :get
  post 'apply' => 'gigs#post_apply'
  post 'jump' => 'gigs#post_jump'
  get 'show_mail/:id' => 'gigs#show_mail', as: "show_mail"
  get 'recreate_mail/:id' => 'gigs#recreate_mail', as: "recreate_mail"
  get 'remove_mail/:id' => 'gigs#remove_mail', as: "remove_mail"
  post 'edit_mail' => 'gigs#edit_mail', as: "edit_mail"
  get 'send_single_mail' => 'gigs#send_single_mail', as: "send_single_mail"

  post 'gigs/create_reminder'
  post 'gigs/create_email'

  get 'locations' => 'gigs#locations'
  post 'locations' => 'gigs#post_locations'
  post 'gigs/edit_location' => 'gigs#edit_location'
  get 'contacts' => 'gigs#contacts'
  post 'contacts' => 'gigs#post_contacts'
  post 'gigs/edit_contact' => 'gigs#edit_contact'

  # get 'fans' => 'gigs#fans'
  # post 'fans' => 'gigs#post_fans'
  # post 'fans/send' => 'gigs#send_to_fans'
  
  get 'map' => 'gigs#map'

  get 'activities' => 'gigs#activities'
  post 'activities' => 'gigs#post_activities'

  root 'gigs#index'
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
