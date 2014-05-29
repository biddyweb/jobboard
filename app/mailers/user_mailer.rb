class UserMailer < ActionMailer::Base

  def password_reset(user)
    @user = user
    mail(
    	:subject => "Job Board Password Reset!",
    	:to => user.email, 
    	:from => 'peter@peterhurford.com'
    )
  end
end