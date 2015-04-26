require "spec_helper"

describe Answer do  
  before(:each) do
    #move this to helper as it shares code with correct answer spec
    @user1 = create(:user)
    @user2 = create(:user)
    @question = create(:question, user_id: @user1.id)
    @answer = create(:answer, correct: false, user: @user1, body: "You can still hook the ball with a weak grip", question_id: @question.id)
    @answer2 = create(:answer, user_id: @user2.id, question_id: @question.id, correct: true)
  end
  
  subject { @answer }
  
  it { should respond_to(:user_id) }
  it { should respond_to(:question_id) }
  it { should respond_to(:body) }
  it { should respond_to(:correct)}
  it { should respond_to(:votes_count)}
  it { should belong_to(:question)}
  it { should belong_to(:user)}
  it { should have_many(:activities)}
  it { should have_many(:comments)}
  it { should have_many(:votes)}
  it { should have_one(:point) }

  describe 'body' do
   before { subject.body = nil }
   it { should_not be_valid }
  end
 
  describe "user_id" do
    before { subject.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "question_id" do
    before { subject.question_id = nil }
    it { should_not be_valid }
  end
  
  describe "length to short" do
    before { subject.body = ("a" * 9) }
    it { should_not be_valid }
  end
  
  describe "length to long" do
    before { subject.body = ("a" * 5001) }
    it { should_not be_valid }
  end
  
  describe "obscenity filter" do
    before { subject.body = "shit" }
    it { should_not be_valid }
  end
  
  describe "to_param" do
    it "appends question title to url" do
      subject.to_param.should eq "#{subject.id}-#{subject.question.title.parameterize}"
    end
  end
  
  describe "is_false" do
    it "returns true when same user" do
      subject.is_false?.should eq true
    end
    
    it "returns false when not same user" do
      @answer2.is_false?.should eq false
    end
  end
  
  describe "check_correct" do
    it "halts destroy if answer is correct" do
      @answer2.check_correct.should eq false
    end
      
    it "allows destroy when true" do  
      subject.check_correct.should eq true
    end
  end
  
  describe "toggle_correct question" do
    it "toggles to true" do
      subject.question.toggle_correct(:correct)
      subject.question.correct.should eq true
    end
  end
  
  describe "Scopes" do
    it "returns an array sorted by votes" do
      @user3 = create(:user)
      @user4 = create(:user)
      a1 = create(:answer, user: @user3, correct: false, body: "your weight shift is incorrect", votes_count: 2, question_id: @question.id) 
      a2 = create(:answer, user: @user4, correct: false, body: "stop moving your head", votes_count: 3, question_id: @question.id) 
      Answer.by_votes.should == [a2, a1, subject, @answer2] 
    end
  end
end