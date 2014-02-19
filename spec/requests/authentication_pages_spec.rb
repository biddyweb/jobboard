require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }
      it { should have_content('Sign In') }
      it { should_not have_link('Sign out?', href: signout_path) }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      it { should have_link('Sign out?', href: signout_path) }
      it { should_not have_link('sign in', href: signin_path) }
      describe "followed by signout" do
      	before { click_link "Sign out?" }
      	it { should have_link('Sign in?', href: signin_path) }
      end
    end

    describe "authorization" do
      describe "for non-signed in users" do
        describe "when attempting to visit a protected page" do
          let(:user) { FactoryGirl.create(:user) }
          before { get new_job_path }
          it { should_not have_content('New job') }
        end
        describe "submitting the create action" do
          before { post jobs_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      describe "after signing in" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user }
        describe "when attempting to visit the new job page" do
          before { visit new_job_path }
          specify { expect(page).to have_content('New job') }
        end
      end

      describe "correct user control" do
        let(:user) { FactoryGirl.create(:user) }
        let(:job) { FactoryGirl.create(:job, user: user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        let(:wrong_job) { FactoryGirl.create(:job, user: wrong_user) }
        before { sign_in user }
        describe "users can edit their own jobs" do
          before { visit edit_job_path(job) }
          specify { save_and_open_page
            expect(page).to have_content('Editing job') }
        end
        describe "users can only edit their own jobs" do
          before { get edit_job_path(wrong_job) }
          specify { expect(response).to redirect_to(signin_url) }
        end
        describe "users can only delete their own jobs" do
          it "should not change job count" do
            expect do
              delete job_path(wrong_job)
            end.to_not change(Job, :count)
          end
        end
        describe "users can delete their own jobs" do
          it "should decrease job count" do
            expect do
              delete job_path(job)
            end.to change(Job, :count).by(-1)
          end
        end
      end
    end
  end
end
