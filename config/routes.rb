ActionController::Routing::Routes.draw do |map|
  map.resources :district_streets

  map.resources :streets

  map.resources :districts

  map.resources :locations

  map.resources :contact_types

  map.root  :controller => 'realties', :action => 'index'
  
  map.resources :users

  map.resources :sessions

  map.resources :list_field_values

  map.resources :realty_fields

  map.resources :realty_field_groups

  map.resources :area_units

  map.resources :currencies

  map.resources :realty_types

  map.resources :realty_purposes

  map.resources :service_types

  map.service '/realties/:service_name', :controller => 'realties', :action => 'index', :requirements => { :service_name => /sale|rent/i}

  map.service '/realties/notepad', :controller => 'realties', :action => 'notepad'

  map.service '/:user_login/realties', :controller => 'realties', :action => 'user_realties'

  map.resources :realties, :collection => { 
                                            :create_user_request => :post,
                                            :update_realty_fields => :any, 
                                            :update_realty_district => :any,
                                            :update_realty_geodata => :post,
                                            :note => :post,
                                            :chart => :get,
                                            :calculate_price => :any
                                          },
                               :member => { :photos => :any, 
                                            :delete_photo => :any, 
                                            :contacts => :any, 
                                            :update_contacts => :any 
                                          }
              
  map.resources :users, :collection => { :add_contact => :any },
                        :member => { :delete_contact => :post, :profile => :get }
  
  map.resource  :session

  map.resource :parser, :collection => { :irr => :any, :start_irr => :post }
  
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
