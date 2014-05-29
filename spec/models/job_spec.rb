require 'spec_helper'

describe Job do

  let(:user) { FactoryGirl.create(:user) }
  before { @job = user.jobs.build(title: "Example", org: "Example", internship: false, postdate: "", filldate: "", location: "Example", description: "Example", link: "http://www.example.com") }
  subject { @job }
  it { should respond_to(:title) }
  it { should respond_to(:org) }
  it { should respond_to(:internship) }
  it { should respond_to(:postdate) }
  it { should respond_to(:filldate) }
  it { should respond_to(:location) }
  it { should respond_to(:description) }
  it { should respond_to(:link) }
  it { should respond_to(:user_id) }
  its(:user) { should eq user }
  it { should be_valid }

  describe "when title is not present" do
    before { @job.title = " " }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { @job.description = " " }
    it { should_not be_valid }
  end

  describe "when title is same but org is different" do
    before do
      same_title_different_org_job = user.jobs.build(title: "Example", org: "Different Example", internship: false, postdate: "", filldate: "", location: "Example", description: "Example", link: "http://www.example.com")
      same_title_different_org_job.save
    end
    it { should be_valid }
  end
  describe "when title is different but org is same" do
    before do
      same_org_different_title_job = user.jobs.build(title: "Different Example", org: "Example", internship: false, postdate: "", filldate: "", location: "Example", description: "Example", link: "http://www.example.com")
      same_org_different_title_job.save
    end
    it { should be_valid }
  end
  describe "when title is same and org is same" do
    before do
      same_job = @job.dup
      same_job.save
    end
    it { should_not be_valid }
  end

end
