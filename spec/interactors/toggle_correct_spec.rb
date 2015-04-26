require 'spec_helper'

describe ToggleAnswerCorrect do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @question = create(:question, user: @user1, correct: false)
    @answer = create(:answer, question_id: @question.id, user: @user2, correct: false)
  end
  
  describe "#toggle" do
    it "should toggle answer and question correct fields when false" do
      AnswerRepository.should_receive(:find_by).with(id: @answer.id).and_return([@answer, true])
      
      result = ToggleAnswerCorrect.call({id: @answer.id})
      
      answer = result.answer
      answer.reload
      answer.correct.should eq true
      answer.question.correct.should eq true
    end
    
    it "should toggle answer and question correct fields and not call update points when same user" do
      answer = create(:answer, question: @question, user: @user1)
      AnswerRepository.should_receive(:find_by).with(id: answer.id).and_return([answer, true])
      PointRepository.should_receive(:mass_update).never
      
      result = ToggleAnswerCorrect.call({id: answer.id})
      
      answer = result.answer
      answer.reload
      answer.correct.should eq true
      answer.question.correct.should eq true
    end
    
    it "should toggle answer and question correct fields when true" do
      user3 = create(:user)
      question = create(:question, user: @user2, correct: true)
      answer = create(:answer, question_id: question.id, user: user3, correct: true)
      
      AnswerRepository.should_receive(:find_by).with(id: answer.id).and_return([answer, true])
      
      result = ToggleAnswerCorrect.call(id: answer.id)
      result.success?.should eq true
      
      answer = result.answer
      answer.reload
      answer.correct.should eq false
      answer.question.correct.should eq false
    end
    
    it "rolls back transaction if toggle_correct fails" do
      AnswerRepository.should_receive(:find_by).with(id: @answer.id).and_return([@answer, true])
      @answer.should_receive(:save).and_return(false)
      
      result = ToggleAnswerCorrect.call(id: @answer.id) 
      
      result.success?.should eq false
      @answer.reload
      @answer.correct.should eq false
      @answer.question.correct.should eq false
    end
    
    it "rolls back transaction if PointRepository.mass_update fails" do
      AnswerRepository.should_receive(:find_by).with(id: @answer.id).and_return([@answer, true])
      PointRepository.should_receive(:mass_update).and_return(false)
      
      result = ToggleAnswerCorrect.call(id: @answer.id) 
      
      result.success?.should eq false
      @answer.reload
      @answer.correct.should eq false
      @answer.question.correct.should eq false
    end
    
    it "returns nil when answer not found" do
      result = ToggleAnswerCorrect.call(id: 999)
      result.success?.should be false
    end
    
    it "returns nil when answer not found" do
      result = ToggleAnswerCorrect.call(another: 'param')
      result.success?.should be false
    end
  end
end