class UsersController < ApplicationController
   before_action :signed_out_user, only: [:new, :create]
   before_action :signed_in_user, only: [:edit, :destroy]
   before_action :correct_user, only: [:edit, :update]
   before_action :admin_user, only: :destroy

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Job Board!"
      redirect_to @user
    else
      render 'new'
    end
  end
      
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], :per_page => 9)
  end
  
  def destroy
    user = User.find(params[:id])
    unless current_user?(user)
      user.destroy
      flash[:success] = "User deleted."
      redirect_to users_path 
    else
      flash[:error] = "You cannot delete yourself."
    end
  end
    
  def new
    @user = User.new
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def edit
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def signed_out_user
      redirect_to(root_url) if signed_in?
  end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end