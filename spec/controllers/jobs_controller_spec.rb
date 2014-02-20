require 'spec_helper'

describe JobsController do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:job) { FactoryGirl.create(:job, user: user) }
  let!(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
  let!(:wrong_job) { FactoryGirl.create(:job, user: wrong_user) }

  describe "sign in control" do
    describe "non-signed users can't create jobs" do
      before { post :create, job: FactoryGirl.create(:job) }
      specify { expect(response).to redirect_to(signin_path) }
    end
    describe "non-signed users can't edit jobs" do
      before { put :update, id: wrong_job.id }
      specify { expect(response).to redirect_to(signin_url) }
    end
    describe "non-signed users can't destroy jobs" do
      it "should not change job count" do
        expect do
          delete :destroy, id: wrong_job.id
        end.to_not change(Job, :count)
      end
      describe "should redirect to signin" do
        before { delete :destroy, id: wrong_job.id }
        specify { expect(response).to redirect_to(signin_url) }
      end
    end
  end

  describe "correct user control" do
    before { sign_in user, no_capybara: true }
    describe "users can only delete their own jobs" do
      it "should not change job count" do
        expect do
          delete :destroy, id: wrong_job.id
        end.to_not change(Job, :count)
      end
    end
    describe "users can delete their own jobs" do
      it "should decrease job count" do
        expect do
          delete :destroy, id: job.id
        end.to change(Job, :count).by(-1)
      end
    end
  end
end
