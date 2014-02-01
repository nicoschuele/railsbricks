class Admin::UsersController < Admin::BaseController
  before_action :set_user, only:[
    :edit,
    :update
  ]
  
  def edit    
  end
  
  def update
    new_params = user_params.dup
    new_params[:username] = new_params[:username].strip
    new_params[:email] = new_params[:email].strip
    if @user.update(new_params)
      redirect_to admin_root_path, notice: "Your account was successfully updated."
    else
      flash[:alert] = "Account not updated."
      render :edit
    end
  end
  
  
  private 
  
  def set_user
    @user = User.friendly.find(current_user.id)
  end
  
  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end
  
end
