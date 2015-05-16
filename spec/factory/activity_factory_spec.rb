require 'spec_helper'

describe ActivityFactory do
  before(:each) do
    @user1 = create :user, username: "Pete-#{rand(1..10)}"
    @user2 = create :user, username: "Arthur-#{rand(1..10)}"
    @question = create :question, user: @user2
    @answer = create :answer, user: @user1, question_id: @question.id
  end
  
  describe '#generate' do
    context 'success' do
      it 'creates activity' do
        factory = ActivityFactory.new @answer
        factory.generate :create, owner: @user1, recipient: @user2
        
        activity = Activity.last
        Activity.count.should be > 0
      end
      
      it 'does not creates activity when owner and recipient are the same' do
        answer = create :answer, user: @user2, question: @question
        factory = ActivityFactory.new answer
        
        expect {
          factory.generate :create, owner: answer.user, recipient: @question.user
        }.to_not change(Activity, :count)
      end
    end
    
    context 'failure' do
      it 'raises ArgumentError with invalid params' do
        factory = ActivityFactory.new @answer
        expect {
          factory.generate :create
        }.to raise_error(ArgumentError)
      end
    end
  end
end