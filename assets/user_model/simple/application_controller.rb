class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  private
  
  # require sign in
  def require_signin!    
    if current_user.nil?
      redirect_to signin_url, alert: "You need to sign in first"
    end
  end
  helper_method :require_signin!
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def user_signed_in?
    current_user ? true : false    
  end
  helper_method :user_signed_in?
  
end