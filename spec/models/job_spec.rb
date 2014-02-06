require 'spec_helper'

describe Job do
  before do 
    @job = Job.new(title: "Example", org: "Example", internship: false, postdate: "", filldate: "", location: "Example", description: "", link: "http://www.example.com")
  end
  subject { @job }
  it { should respond_to(:title) }
  it { should respond_to(:org) }
  it { should respond_to(:internship) }
  it { should respond_to(:postdate) }
  it { should respond_to(:filldate) }
  it { should respond_to(:location) }
  it { should respond_to(:description) }
  it { should respond_to(:link) }

  describe "when title is not present" do
    before { @job.title = " " }
    it { should_not be_valid }
  end

  describe "when title is same but org is different" do
    before do
      same_title_different_org_job = @job = Job.new(title: "Example", org: "Different Example", internship: false, postdate: "", filldate: "", location: "Example", description: "", link: "http://www.example.com")
      same_title_different_org_job.save
    end
    it { should be_valid }
  end
  describe "when title is different but org is same" do
    before do
      same_org_different_title_job = @job = Job.new(title: "Different Example", org: "Example", internship: false, postdate: "", filldate: "", location: "Example", description: "", link: "http://www.example.com")
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
