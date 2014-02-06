class Job < ActiveRecord::Base
	validates :title, presence: true
	validates_uniqueness_of :title, :scope => :org
end
