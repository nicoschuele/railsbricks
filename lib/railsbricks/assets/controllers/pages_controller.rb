class PagesController < ApplicationController
  before_action :authenticate_user!, only: [
    :inside
  ]

  def home
  end
  
  def inside
  end
  BRICK_POSTS_CONTROLLER 
  BRICK_CONTACT_CONTROLLER  
end
