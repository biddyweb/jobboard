class UsersController < ApplicationController
  skip_before_action :require_signin, only: [:new, :create]
  skip_before_action :correct_user, only: [:new, :create]
  before_action :signed_out_user, only: [:create]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  	  sign_in @user
  	  flash[:success] = "Welcome to the Job Board."
  	  redirect_to root_path
  	else
  	  render 'new'
  	end
  end

  private
  	def user_params
  	  params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    def signed_out_user
      redirect_to(root_url) if signed_in?
    end
end