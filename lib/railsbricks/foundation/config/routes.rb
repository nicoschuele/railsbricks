BRICK_APP_NAME::Application.routes.draw do
      
  root "pages#home"
  
  get "/home", to: "pages#home", as: "home"
  BRICK_CONTACT_ROUTES
end
