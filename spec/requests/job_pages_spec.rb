require 'spec_helper'

describe "JobPages" do
  subject { page }
  
  describe "Index" do
    describe "While not logged in" do
    	before { visit root_path }
    	it { should have_link('Sign up to add new jobs...', signup_path) }
      it { should have_link('Sign in?', signin_path) }
      it { should have_link('Sign up!', signup_path) }
      it { should_not have_link('Sign out?', signout_path) }
      it { should_not have_link('Add a new job?', new_job_path) }
    end
    describe "After logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit root_path
      end
      it { should_not have_link('Sign up to add new jobs...', signup_path) }
      it { should_not have_link('Sign in?', signin_path) }
      it { should_not have_link('Sign up!', signup_path) }
      it { should have_link('Sign out?', signout_path) }
      it { should have_link('Add a new job?', new_job_path) }
    end
  end

  describe "Create" do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
  		sign_in user
  		visit new_job_path
  		fill_in "Title", with: "Sample Title"
  		fill_in "Org", with: "Sample Org"
  		fill_in "Postdate", with: nil
  		fill_in "Filldate", with: nil
  		fill_in "Location", with: "Sample Location"
  		fill_in "Link", with: "http://www.example.com"
  		fill_in "Description", with: "Sample Description"
  	end
  	it "should create a job" do
  		expect { click_button "Submit" }.to change(Job, :count)
  	end
  end

  describe "Read" do
  	let(:job) { FactoryGirl.create(:job) }
  	before { visit job_path(job) }
  	it { should have_text(job.title) }
  end

  # Update tested in authentication_pages_spec
  # Destroy tested in jobs_controller_spec

end