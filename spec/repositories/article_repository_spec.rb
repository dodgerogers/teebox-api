require 'spec_helper'

describe ArticleRepository do
  before(:each) do
    @article = create(:article)
  end
  
  describe 'transition' do
    it 'returns true and success message' do
      Article.any_instance.stub(:submit).and_return(true)
      success, message = ArticleRepository.transition(@article, :submit)
      
      success.should be true
      message.should include 'successful'
    end
    
    it 'returns false and failure message' do
      Article.any_instance.stub(:submit).and_return(false)
      success, message = ArticleRepository.transition(@article, :submit)
      
      success.should be false
      message.should include 'failed'
    end
    
    it 'raises error when not supplied a valid article object' do
      expect {
        ArticleRepository.transition('not an article', :submit)
      }.to raise_error
    end
  end
end