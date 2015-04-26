require "spec_helper"

describe Point do
  before(:each) do
    @user2 = create(:user)
    @user = create(:user)
    @question = create(:question, user: @user2)
    @answer = create(:answer, user: @user, question_id: @question.id)
    @vote = create(:vote, user: @user2, votable: @answer)
    @point = create(:point, pointable: @vote, user_id: @user.id)
  end
  
  subject { @point }
  
  it { should respond_to(:value) }
  it { should respond_to(:user_id) }
  it { should respond_to(:pointable_id) }
  it { should respond_to(:pointable_type) }
  
  describe "find_points" do
    it "return array of scoped point objects" do
      Point.find_points(@user).should eq [@point]
    end
  end
end