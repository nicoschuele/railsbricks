BRICK_APP_NAME::Application.routes.draw do
  root "pages#home"    
  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"
  BRICK_CONTACT_ROUTES
  BRICK_POST_ROUTES    
  devise_for :users
  
  namespace :admin do
    root "base#index"
    resources :users
    BRICK_ADMIN_POST_ROUTES
  end
  
end
