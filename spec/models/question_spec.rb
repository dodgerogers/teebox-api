require 'spec_helper'
include TagHelper
include VideoHelper
include QuestionHelper

describe Question do
  before(:each) do
    @user = create(:user)
    @question = create(:question, user: @user)
  end
  
  subject { @question }
  
  it { should respond_to(:title) }
  it { should respond_to(:body) }
  it { should respond_to(:youtube_url) }
  it { should respond_to(:user_id) }
  it { should respond_to(:votes_count)}
  it { should respond_to(:answers_count)}
  it { should respond_to(:impressions_count)}
  it { should respond_to(:correct)}
  it { should belong_to(:user)}
  it { should have_many(:comments)}
  it { should have_many(:votes)}
  it { should have_many(:answers)}
  it { should have_many(:tags).through(:taggings)}
  it { should have_many(:taggings)}
  it { should have_many(:videos).through(:playlists)}
  it { should have_many(:playlists)}
  it { should have_many(:impressions)}
  it { should have_one(:point) }
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:body)}
  it { should validate_presence_of(:user_id)}
  
  describe "exceed tag_limit" do
    before { subject.tags << tag_list }
    it { should_not be_valid }
  end
  
  describe "exceed video_limit" do
    before { subject.videos << 4.times.map { create(:video) } }
    it { should_not be_valid }
  end
  
  describe 'self.videos' do
    before(:each) do
      @video = create(:video, user: @user)
      subject.videos << @video
    end
    
    describe "video_list" do
      it "video_list setter" do
        subject.video_list.should include @video.id.to_s
      end
    
      it "video_list getter" do
        subject.videos.should include(@video)
      end
    end
  
    describe 'ensure_own_videos adds errors' do
      before { subject.videos << create(:video, user: create(:user)) }
      it { should_not be_valid }
    end
  end    
  
   describe "long title" do
     before { subject.title = ("a" * 91) }
      it { should_not be_valid }
   end
   
   describe "short title" do
      before { subject.title = ("a" * 9) }
       it { should_not be_valid }
    end
    
    describe "long body content" do
      before { subject.body = ("a" * 5001) }
      it { should_not be_valid }
    end
    
    describe "obscenity filter title" do
      before { subject.title = "shit" }
      it { should_not be_valid }
    end
    
    describe "validates body" do
      before { subject.body = "fuck" }
      it { should_not be_valid }
    end
    
    describe "tagged_with " do
      it "finds a tag by name" do
        @tag = create(:tag, name: "shank")
        subject.tags << @tag
        Question.tagged_with(@tag.name).should include subject
      end
    end
    
    describe "Question.search" do
      before(:each) do
         @question = create(:question, title: 'I need help with my driver')
         @question_2 = create(:question, title: "I'm not hitting my driver well")
         @question_3 = create(:question, title: 'My short game needs some help')
       end
       
      it "returns [] when search nil" do
        result = Question.search("")
        result.should_not include(@question, @question_2, @question_3, subject)
        result.should eq []
      end
      
      it 'should return similar questions' do
        Question.search("driver").should include(@question, @question_2)
      end
       
      it 'should not return similar questions' do
        Question.search("putting").should_not include(@question, @question_2, @question_3, subject)
      end
    end

    describe "Scopes" do
      before(:each) do
        @user1 = create(:user)
        create_questions(@user1) # sets the q1 etc instance vars
      end
      
      it "returns unanswered questions" do 
        Question.unanswered.should include(@q2, subject, @q3)
      end
    
      it "returns questions by votes" do 
        Question.popular.should include(subject, @q3, @q2, @q1)
      end
    
      it "newest returns questions by date" do 
        Question.newest.should == [@q3, @q2, @q1, subject] 
      end
   end
end