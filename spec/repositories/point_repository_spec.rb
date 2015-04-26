require "spec_helper"

describe PointRepository do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @question = create(:question, user: @user1, correct: false)
    @answer = create(:answer, question_id: @question.id, user: @user2, correct: false)
  end
  
  describe '#create' do
    context 'success' do
      it 'saves point to db' do
        expect {
          PointRepository.create(@user2, @answer)
        }.to change(Point, :count)
      end
    end
    
    context 'failure' do
      it 'does not save point' do
        Point.any_instance.should_receive(:save).and_return(false)
        expect {
          PointRepository.create(@user2, @answer)
        }.to_not change(Point, :count)
      end
    end
  end
  
  describe "#mass_update" do
    it "success #find_and_update for the number of args provided and return true" do
      PointRepository.should_receive(:find_and_update).twice
      
      result = PointRepository.mass_update({entry: @answer, value: 12}, {entry: @question, value: 5})
      result.should eq true
    end
    
    it "failure #find_and_update returns false" do
      PointRepository.should_receive(:find_and_update).twice.and_return(false)
      
      result = PointRepository.mass_update({entry: @answer, value: 12}, {entry: @question, value: 5})
      result.should eq false
    end
  end
  
  describe "#find_and_update" do
    it "updates points for given objects" do
      PointRepository.find_and_update({entry: @answer, value: 12})
      PointRepository.find_and_update({entry: @question, value: 5})
      
      @answer.reload
      @question.reload
      @answer.point.value.should eq 12
      @question.point.value.should eq 5
    end
    
    it "raises Argument Error when not supplied a hash" do
      expect { 
        PointRepository.find_and_update("string argument") 
      }.to raise_error(ArgumentError)
    end
    
    it "raises Argument Error when value is not an integer" do
      expect { 
        PointRepository.find_and_update({entry: @answer, value: "string"}) 
      }.to raise_error(ArgumentError)
    end
  end
end