require 'spec_helper'
require "json"

describe Video do
  before(:each) do
    @video = create(:video)
  end
  
  subject { @video }
  
  it { should respond_to(:user_id) }
  it { should respond_to(:file) }
  it { should respond_to(:screenshot) }
  it { should respond_to(:job_id) }
  it { should respond_to(:status) }
  it { should respond_to(:duration) }
  it { should respond_to(:location) }
  it { should respond_to(:name) }
  it { should have_many(:questions).through(:playlists) }
  it { should have_many(:playlists)}
  it { should belong_to(:user) }
  
  describe 'file' do
     before { subject.file = nil }
     it { should_not be_valid }
   end
   
  describe "user_id" do
    before { subject.user_id = nil }
    it { should_not be_valid }
  end
    
  describe "get_key" do
    it "extracts the aws key" do
      subject.aws_file_key.should eq "uploads/video/file/22120817-19bf-40ec-96f1-3c904772370b/3-wood-creamed.m4v"  
    end 
  end
end