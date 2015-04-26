require "spec_helper"

describe VotesController do
  include Devise::TestHelpers
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user1.confirm!
    @user2.confirm!
    sign_in @user1
    sign_in @user2
    @question = create(:question, user: @user2)
    @answer = create(:answer, user: @user1, question_id: @question.id)
    @vote = attributes_for(:vote, votable_id: @answer.id, user_id: @user2, votable_type: "Answer", value: 1)
    controller.stub!(:current_user).and_return(@user1)
    @request.env['HTTP_REFERER'] = "http://test.host/questions/"
  end
  
  describe "POST vote" do
    it "creates vote with valid params for answer" do
      controller.stub(:current_user).and_return(@user2)
      expect {
        post :create, vote: { votable_id: @answer.id, votable_type: @answer.class, value: 1 }
      }.to change(Vote, :count).by(1)
    end
    
    it "fails with invalid params for answer" do
      controller.stub(:current_user).and_return(@user2)
      expect {
        post :create, vote: { votable_id: @answer.id, votable_type: @answer.class, value: nil }
      }.to_not change(Vote, :count).by(1)
    end
  end
end
