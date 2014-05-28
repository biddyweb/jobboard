class PasswordResetsController < ApplicationController
	skip_before_action :require_signin
	skip_before_action :correct_user

  def new
  end

  def create
  	user = User.find_by_email(params[:email])
  	user.send_password_reset if user
  	if user
  		flash[:success] = "Password reset email sent.  It may take awhile to arrive, though..."
  	else
  		flash[:error] = "Email not found."
  	end
  	redirect_to root_path
  end

  def edit
  	@user = User.find_by_password_reset_token!(params[:id])
  end

  def update
  	@user = User.find_by_password_reset_token!(params[:id])
  	if @user.password_reset_sent_at < 2.hours.ago
  		flash[:error] = "Password reset token has expired.  Please request again."
  		redirect_to new_password_reset_path
  	elsif @user.update_attributes(params[:user])
  		flash[:success] = "Password has been reset!"
  		redirect_to root_path
  	else
  		render :edit
  	end
  end
end
