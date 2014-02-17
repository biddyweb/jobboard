class Job < ActiveRecord::Base
	belongs_to :user
	validates :title, presence: true
	validates :user_id, presence: true
	validates_uniqueness_of :title, :scope => :org
end
