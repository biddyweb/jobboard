class JobsController < ApplicationController
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
		@job = Job.new(job_params)
		respond_to do |format|
			if @job.save
				format.html { redirect_to @job, notice: 'Job was successfully created.' }
				format.json { render action: 'show', status: :created, location: @job }
			else
				format.html { render action: 'new' }
				format.json { render json: @job.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @job.update(job_params)
				format.html { redirect_to @job, notice: 'Job was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @job.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@job.destroy
		respond_to do |format|
			format.html { redirect_to jobs_url }
			format.json { head :no_content }
		end
	end

	private
		def set_job
			@job = Job.find(params[:id])
		end
	
		def job_params
			params.require(:job).permit(:title, :org, :internship, :postdate, :filldate, :location, :link, :description)
		end
end