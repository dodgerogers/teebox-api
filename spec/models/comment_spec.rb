require 'spec_helper'

describe Comment do
  before(:each) do
    @user1 = create(:user, username: "dodgerogers747")
    @user2 = create(:user, username: "randyrogers")
    @question = create(:question, user: @user1, title: "My swing is too short", body: "my flexibility isn't great")
    @comment = create(:comment, commentable_id: @question.id, content: "this is a comment for @randyrogers", user: @user1)
    Comment.any_instance.stub(:display_mentions).and_return(@comment)
  end
  
  subject { @comment }
  
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:commentable) }
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }
  it { should have_many(:activities) }
  it { should have_many(:votes) }
  it { should have_one(:point) }
  it { should validate_length_of(:content).is_at_least(10) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:commentable_id) }
  it { should validate_presence_of(:commentable_type) }
  
  describe 'content' do
    before { subject.content = nil }
    it { should_not be_valid }
  end
   
  describe 'short content' do
    before { subject.content = "comment" }
    it { should_not be_valid }
  end
  
  describe 'long content' do
    before { subject.content = ('a' * 501) }
    it { should_not be_valid }
  end
    
  describe "obscenity filter" do
    before { subject.content = "shit" }
    it { should_not be_valid }
  end

  describe "user_id" do
    before { subject.user_id = nil }
    it { should_not be_valid }
  end

  describe "commentable id" do
    before { subject.commentable_id = nil }
    it { should_not be_valid }
  end

  describe "commentable type" do
    before { subject.commentable_type = nil }
    it { should_not be_valid }
  end 
  
  describe "find_mentions" do
    it "returns array of names" do
      subject.find_mentions.should eq(["randyrogers"])
    end
  end

  describe "mentions" do
    describe "display_mentions" do
      it "containing valid user" do
        subject.display_mentions.content.should eq("this is a comment for <a href='/users/#{@user2.id}-#{@user2.username}'>@#{@user2.username}</a>")
      end
    
      it "no valid users" do
        subject.content = "hey @dodgey this is a comment"
        subject.display_mentions.content.should eq("hey @dodgey this is a comment")
      end
      
      it "contains duplicate users" do
        comment = FactoryGirl.build(:comment, content: "hey @randyrogers this is a comment @randyrogers", commentable_id: @question.id)
        comment.valid?
        comment.errors[:content].should eq ["You can only mention someone once"]
      end
    end
  end
end