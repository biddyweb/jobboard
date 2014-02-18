class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :require_signin
  before_filter :correct_user
  
  include SessionsHelper

  private
  	def require_signin
    	unless signed_in?
      	store_location
      	redirect_to signin_url, notice: "Please sign in."
    	end
  	end

  	def correct_user
			@job = current_user.jobs.find_by(id: params[:id])
      redirect_to root_url if @job.nil?
    end
end
