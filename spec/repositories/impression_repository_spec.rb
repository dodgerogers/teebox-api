require 'spec_helper'

describe ImpressionRepository do
  before(:each) do
    @user = create(:user)
    @question = create(:question, user: @user)
    @request = double()
    @request.stub(:remote_ip).and_return('12.34.56.78')
  end
  
  describe '#create' do
    context 'success' do
      it 'saves impression to db' do
        expect {
          ImpressionRepository.create(@question, @request)
        }.to change(Impression, :count)
      end
    end
    
    context 'failure' do
      it 'does not create impression when save fails' do
        Impression.any_instance.should_receive(:save).and_return(false)
        
        expect {
          ImpressionRepository.create(@question, @request)
        }.to_not change(Impression, :count)
      end
      
      it 'raises ArgumentError when request is not valid' do
        @request.stub(:remote_ip).and_return(false)
        
        expect {
          ImpressionRepository.create(@question, @request)
        }.to raise_error(ArgumentError)
      end
      
      it 'raises NotImplementedError if record does not have impressions implemented' do
        expect {
          ImpressionRepository.create(create(:user), @request)
        }.to raise_error(NotImplementedError)
      end
    end
  end
end