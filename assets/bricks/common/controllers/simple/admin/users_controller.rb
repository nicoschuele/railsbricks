class Admin::UsersController < Admin::BaseController
  before_action :set_user, only:[
    :edit,
    :update
  ]
  
  def edit    
  end
  
  def update
    if @user.update(user_params)
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
