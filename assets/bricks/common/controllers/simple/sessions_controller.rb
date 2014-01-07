class SessionsController < ApplicationController
  def new
    redirect_to(root_path, notice: "You are already signed in.") if current_user 
  end
  
  def create
    user = User.where(username: params[:signin][:username].strip).first

    if user && user.authenticate(params[:signin][:password])
    
      session[:user_id] = user.id 
      redirect_to admin_root_path, notice: "Signed in successfully."
    else
      flash[:error] = "Wrong username/password."
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out."
  end
  
end
