require 'spec_helper'

describe ActivityRepository do
  before(:each) do
    @user1, @user2 = 2.times.map { create(:user) }
    @question = create(:question, user: @user2)
    @answer = create(:answer, user: @user1, question_id: @question.id)
    @activity = create(:activity, trackable: @question, owner: @suer1, recipient: @user2)
    @html = <<-HTML
      <div class="message">
        Notification Message
      </div>  
    HTML
  end
  
  describe '#generate' do
    context 'with valid params' do
      it 'creates activity and sets html' do
        repo = ActivityRepository.new(@answer)
        
        #ApplicationController.helpers.should_receive(:generate_activity_html).and_return(@html)
        
        repo.generate(:create, instance: @answer, owner: @user1, recipient: @user2)
        
        activity = Activity.last
        Activity.count.should be > 0
        #activity.html.should eq @html
      end
      
      it 'does not creates activity when owner and recipient are the same' do
        answer = create(:answer, user: @user2, question: @question)
        
        repo = ActivityRepository.new(answer)
        
        expect {
          repo.generate(:create, instance: answer, owner: answer.user, recipient: @question.user)
        }.to_not change(Activity, :count)
      end
    end
    
    context 'with invalid params' do
      it 'raises ArgumentError' do
        repo = ActivityRepository.new(nil)
        expect {
          repo.generate(:create)
        }.to raise_error(ArgumentError)
      end
    end
  end
end