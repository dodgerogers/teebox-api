require "spec_helper"

describe AnswerRepository do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @question = create(:question, user: @user1, correct: false)
    @answer = create(:answer, question_id: @question.id, user: @user2, correct: false)
  end
  
  describe "find_and_update" do
   context "success" do
      it "returns updated activity" do
        repo = AnswerRepository.new @user2
        result = repo.find_and_update id: @answer.id, correct: true
        
        result.entity.reload
        result.success?.should eq true
        result.entity.correct.should eq true
      end
    end
    
    context "failure" do
      it "returns errors and does not update activity" do
        Answer.any_instance.stub(:save).and_return false
        
        repo = AnswerRepository.new @user2
        result = repo.find_and_update id: @answer.id, correct: true

        result.entity.reload
        result.success?.should eq false
        result.entity.correct.should_not eq true
      end
    end
  end
  
  describe "find_by" do
    context "when called with id params" do
      context "success" do
        it "returns activity" do
          repo = AnswerRepository.new @user2
          result = repo.find_by id: @answer.id
          
          result.success?.should eq true
          result.entity.should eq @answer
        end
      end
      
      context "failure" do
        it "returns errors" do
          repo = AnswerRepository.new @user2
          result = repo.find_by id: 9999999
          
          result.success?.should eq false
          result.entity.should eq nil
        end
      end
    end
  end
  
  describe "find_and_destroy" do
    context "success" do
      it "returns success" do
        repo = AnswerRepository.new @user2
        result = repo.find_and_destroy id: @answer.id
        
        result.success?.should eq true
      end
    end
    
    context "failure" do
      it "returns errors" do
        repo = AnswerRepository.new @user2
        result = repo.find_and_destroy id: 9999999
        
        result.success?.should eq false
        result.errors[:message].should include "not found"
      end
    end
  end
end