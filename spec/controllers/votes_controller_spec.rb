require "spec_helper"

describe Api::VotesController do
  include Devise::TestHelpers
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user1.confirm!
    @user2.confirm!
    @question = create(:question, user: @user2)
    @answer = create(:answer, user: @user1, question_id: @question.id)
    @vote = attributes_for(:vote, votable_id: @answer.id, user_id: @user2, votable_type: "Answer", value: 1)
    @params = { 
      user_token: @user2.authentication_token, 
      user_email: @user2.email
    }
  end
  
  describe "POST vote" do
    context "success" do
      it "returns 200 and vote" do
        PointRepository.should_receive(:create).and_return true
        
        post :create, @params.merge(vote: { votable_id: @answer.id, votable_type: @answer.class, value: 1 })
       
        response.should be_success
      end
    end
    
    context "failure" do
      it "fails with invalid params for answer" do
        Vote.any_instance.stub(:save).and_return(false)
        
        post :create, @params.merge(vote: { votable_id: @answer.id, votable_type: @answer.class, value: 1 })
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
end
