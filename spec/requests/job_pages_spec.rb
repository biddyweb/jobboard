require 'spec_helper'

describe "JobPages" do
  subject { page }
  
  describe "Index" do
    before { visit root_path }
    it { should have_link('sign in', href: signin_path) }
  end
end