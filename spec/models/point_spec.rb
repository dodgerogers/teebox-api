require "spec_helper"

describe Point do
  before(:each) do
    @user2 = build(:user)
    @user = build(:user)
    @question = build(:question, user: @user2)
    @answer = build(:answer, user: @user, question: @question)
    @vote = build(:vote, user: @user2, votable: @answer)
    @point = build(:point, pointable: @vote, user: @user)
  end
  
  subject { @point }
  
  it { should respond_to(:value) }
  it { should respond_to(:user_id) }
  it { should respond_to(:pointable_id) }
  it { should respond_to(:pointable_type) }
  
  describe "find_points" do
    it "return array of scoped point objects" do
      user = create(:user)
      point = create(:point, pointable: @vote, user: user)
      
      Point.find_points(user).should eq [point]
    end
  end
end