require "spec_helper"

describe AnswerRepository do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @question = create(:question, user: @user1, correct: false)
    @answer = create(:answer, question_id: @question.id, user: @user2, correct: false)
  end
  
  describe "#find_by" do
    it "returns answer and success when answer is found" do
      answer, success = AnswerRepository.find_by(id: @answer.id)
      
      answer.should eq @answer
      success.should eq true
    end
    
    it 'returns nil and false when not found' do
      answer, success = AnswerRepository.find_by(id: 999)
      
      answer.should eq nil
      success.should eq false
    end
  end
end