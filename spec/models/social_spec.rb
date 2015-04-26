require "spec_helper"

describe Statistics::Social do
  before(:each) do
    @social = create(:social)
  end
  
  subject { @social }
  
  it { should respond_to(:likes) }
  it { should respond_to(:followers) }
  it { should respond_to(:generate) }
  it { validate_presence_of(:likes) }
  it { validate_presence_of(:followers) }
  
  describe "NEW" do
    it "should instantiate a new Social object" do
      Statistics::Social.new.should be_a_kind_of(Statistics::Social)
    end
  end
end