class SessionsController < ApplicationController
  skip_before_action :require_signin, only: [:new, :create]
  skip_before_action :correct_user, only: [:new, :create, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:destroy]

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      flash[:success] = 'You are now signed in.'
  	  sign_in user
  	  redirect_back_or root_url
  	else
  	  flash.now[:error] = 'Invalid email / password combination.'
  	  render 'new'
  	end
  end

  def destroy
    sign_out
    flash[:success] = 'You are now signed out.'
    redirect_to root_url
  end
end
