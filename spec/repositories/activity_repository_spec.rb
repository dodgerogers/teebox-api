require 'spec_helper'

describe ActivityRepository do
  before(:each) do
    @user1, @user2 = 2.times.map { create(:user) }
    @question = create :question, user: @user2
    @answer = create :answer, user: @user1, question_id: @question.id
    @activity = create :activity, trackable: @question, owner: @user1, recipient: @user2
  end
  
  describe "find_all" do
    it "returns @user2's activities" do
      repo = ActivityRepository.new @user2
      result = repo.find_all
      
      result.success?.should eq true
      result.collection.should include @activity
    end
  end
  
  describe "find_and_update" do
   context "success" do
      it "returns updated activity" do
        repo = ActivityRepository.new @user2
        result = repo.find_and_update id: @activity.id, read: true
        
        result.entity.reload
        result.success?.should eq true
        result.entity.read.should eq true
      end
    end
    
    context "failure" do
      it "returns errors and does not update activity" do
        Activity.any_instance.stub(:save).and_return false
        
        repo = ActivityRepository.new @user2
        result = repo.find_and_update id: @activity.id, read: true

        result.entity.reload
        result.success?.should eq false
        result.entity.read.should_not eq true
      end
    end
  end
  
  describe "find_by" do
    context "when called with id params" do
      context "success" do
        it "returns activity" do
          repo = ActivityRepository.new @user2
          result = repo.find_by id: @activity.id
          
          result.success?.should eq true
          result.entity.should eq @activity
        end
      end
      
      context "failure" do
        it "returns errors" do
          repo = ActivityRepository.new @user2
          result = repo.find_by id: 9999999
          
          result.success?.should eq false
          result.entity.should eq nil
        end
      end
    end
  end
end