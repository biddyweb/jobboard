require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }
    let(:submit) { "Create Account" }
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(:email, 'user@example.com') }
        it { should have_link('Sign out?', href: signout_path) }
      end
    end
  end

  describe "sign in and sign out" do
    describe "sign in" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
      end
      it { should have_link('Sign out?', href: signout_path) }
      it { should_not have_link('Sign in?', href: signin_path) }
    end
    describe "sign out" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        click_link 'Sign out?'
      end
      it { should_not have_link('Sign out?', href: signout_path) }
      it { should have_link('Sign in?', href: signin_path) }
    end
  end
end