class JobsController < ApplicationController
	skip_before_action :require_signin, only: [:index, :show]
	skip_before_action :correct_user, only: [:index, :show, :new, :create]
	before_action :set_job, only: [:show, :edit, :update, :destroy]

	def index
		@jobs = Job.all
	end

	def show
	end

	def new
		@job = Job.new
	end

	def edit
	end

	def create
		@job = current_user.jobs.build(job_params)
		job_params[:description] = markdown_to_html(job_params[:description])
		respond_to do |format|
			if @job.save
				format.html do
					redirect_to @job
					flash[:success] = "Job created.  #{view_context.link_to('Create another?', new_job_path)}".html_safe
				end
				format.json { render action: 'show', status: :created, location: @job }
			else
				format.html { render action: 'new' }
				format.json { render json: @job.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		job_params[:description] = markdown_to_html(job_params[:description])
		respond_to do |format|
			if @job.update(job_params)
				format.html do
					redirect_to @job
					flash[:success] = 'Job updated.'
				end
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @job.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@job.destroy
		flash[:success] = 'Job destroyed.'
		respond_to do |format|
			format.html { redirect_to jobs_url }
			format.json { head :no_content }
		end
	end

	def markdown_to_html(input)
		input.gsub!(/(#+)(.*)/, '<h2>\2</h2>')															# Headers
		input.gsub!(/\[([^\[]+)\]\(([^\)]+)\)/, '<a href=\'\2\'>\1</a>')		# Links
		input.gsub!(/(\*\*|__)(.*?)\1/, '<strong>\2</strong>')							# Bold
		input.gsub!(/(\*|_)(.*?)\1/, '<em>\2</em>')													# Italics
		input.gsub!(/`(.*?)`/, '<code>\1</code>')														# Inline Code
		input.gsub!(/\n\*(.*)/, '<li>\1</li>')															# Lists
		input.gsub!(/\n(&gt;|\>)(.*)/, '<blockquote>\1</blockquote>')				# Blockquotes
		input.gsub!(/\n-{5,}/, '\n<hr />')																	# Horizontal rules
		input.gsub!(/\n/, '<br>')																						# Paragraphs
		input
	end

	private
		def set_job
			@job = Job.find(params[:id])
		end
	
		def job_params
			params.require(:job).permit(:title, :org, :internship, :postdate, :filldate, :location, :link, :description)
		end
end
