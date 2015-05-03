require "spec_helper"

describe Vote do
  before(:each) do
    @user2 = build(:user)
    @user = build(:user)
    @question = build(:question, user: @user2)
    @answer = build(:answer, user: @user, question: @question)
    @vote = build(:vote, user: @user2, votable: @answer)
  end
  
  subject { @vote }
  
  it { should respond_to(:user_id) }
  it { should respond_to(:votable_id) }
  it { should respond_to(:votable_type) }
  it { should respond_to(:value) }
  it { should respond_to(:points) }
  it { should belong_to(:votable) }
  it { should belong_to(:user) }
  it { should have_one(:point) }
  it { should validate_uniqueness_of(:value).scoped_to([:votable_id, :user_id])}
  it { should validate_inclusion_of(:value).in_array([1, -1]) }
  
   describe 'value' do
     before { subject.value = nil }
     it { should_not be_valid }
   end
   
   describe "user_id" do
     before { subject.user_id = nil }
     it { should_not be_valid }
   end
     
   describe "votable_id" do
     before { subject.votable_id = nil }
     it { should_not be_valid }
   end
    
   describe "votable type" do
    before { subject.votable_type = nil }
    it { should_not be_valid }
   end
  
   describe "vote value" do
    before { subject.value = 5 }
    it { should_not be_valid }
   end
   
   describe 'ensure_not_author' do
     before { subject.votable = create(:answer, user: create(:user), question: create(:question)) }
     it { should_not be_valid }
   end
   
   describe "sum_points" do
     before :each do
       @vote_with_points = create(:vote, user: create(:user), votable: create(:question))
     end
     
    it "adds points for value" do
      @vote_with_points.sum_points("value").should eq 1
    end
    
    it "adds points for points" do
      @vote_with_points.sum_points("points").should eq 5
    end
  end
end