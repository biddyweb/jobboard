class UsersController < ApplicationController
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

  	def signed_in_user
  	  redirect_to signin_url, notice: "You must sign in first." unless signed_in?
  	end
end