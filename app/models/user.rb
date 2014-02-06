class User < ActiveRecord::Base
  has_many :jobs
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_secure_password

  def User.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
  	Digest::SHA1.hexdigest(token.to_s)
  end

  private
  	def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end