class User < ActiveRecord::Base
	has_many :jobs
	before_save { self.email = email.downcase }
	before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.\_]+@[a-z\d\-]+\.[a-z\d\-\_]+\.?[a-z\d\-\_]+?\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	has_secure_password

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		Micropost.from_users_followed_by(self)
	end

	private
	def create_remember_token
		self.remember_token = User.encrypt(User.new_remember_token)
	end
end