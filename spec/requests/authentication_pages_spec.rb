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
      	it { should have_link('sign in', href: signin_path) }
      end
    end

    describe "authorization" do
      let(:job) { FactoryGirl.create(:job) }
      describe "in Jobs" do
      	describe "trying to create" do
      	  before { post jobs_path }
          specify { expect(response).to redirect_to(signin_path) }
       	end
        describe "trying to destroy" do
          before { delete jobs_path(:job) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end
  end
end