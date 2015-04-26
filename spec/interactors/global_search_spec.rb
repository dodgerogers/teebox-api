require 'spec_helper'

describe GlobalSearch do
  before(:each) do
    @user = create :user
    @article1 = create :article, user: @user, title: "Driver article", state: Article::PUBLISHED
    @article2 = create :article, user: @user, title: "Putting article", state: Article::PUBLISHED
    @article3 = create :article, user: @user, title: "Chipping article", state: Article::PUBLISHED
    
    @question1 = create :question, user: @user, title: "How do i improve my driver" 
    @question2 = create :question, user: @user, title: "How do i improve my chipping"
    @question3 = create :question, user: @user, title: "Tiger woods through the years"
  end
  
  describe '#call' do
    context 'valid params' do
      it 'returns an empty hash when no matching results' do
        result = GlobalSearch.call(search: 'short game')
        
        result.collection[:articles].should eq []
        result.collection[:questions].should eq []
        result.total.should eq 0
      end
      
      it 'returns matching questions and articles' do
        result = GlobalSearch.call(search: 'driver')
        
        result.collection[:articles].should include(@article1)
        result.collection[:questions].should include(@question1)
        result.total.should eq 2
      end
      
      it 'returns only published articles' do
        Article::VALID_STATES.each {|state| create(:article, user: @user, title: state, state: state) }
        
        result = GlobalSearch.call(search: 'publish')
        
        result.collection[:articles].count.should eq 1
        result.collection[:questions].count.should eq 0
        result.collection[:users].count.should eq 0
        result.total.should eq 1
      end
      
      it 'only returns matching questions' do
        result = GlobalSearch.call(search: 'tiger')
        
        result.collection[:articles].should eq []
        result.collection[:questions].should include(@question3)
        result.total.should eq 1
      end
    end
    
    context 'invalid params' do
      it 'fails with invalid query params' do
        result = GlobalSearch.call(search: Struct.new(:name))
        
        result.success?.should eq false
        result.message.should include(GlobalSearch::SEARCH_PARAMS_ERROR)
      end
      
      it 'fails when model does respond to search method' do
        Article.stub(:respond_to?).with(:search).and_return(false)
        result = GlobalSearch.call(search: 'search term')
        
        result.success?.should eq false
        result.message.should include(sprintf(GlobalSearch::NOT_IMPLEMENTED_ERR, 'Article'))
      end
    end
  end
end