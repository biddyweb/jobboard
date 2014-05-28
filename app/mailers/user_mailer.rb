class UserMailer < ActionMailer::Base
  default from: "robot@jobboard.im"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Job Board Password Reset!"
  end
end