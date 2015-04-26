require 'spec_helper'

describe Article do
  before(:each) do
    @article = create(:article)
  end
  
  subject { @article }
  
  it { should respond_to(:user_id) }
  it { should respond_to(:title) }
  it { should respond_to(:body) }
  it { should belong_to(:user)}
  it { should have_many(:impressions)}
  it { should have_many(:comments)}
  it { should have_many(:votes)}
  it { should have_one(:point) }
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:body)}
  it { should validate_presence_of(:user_id)}
  it { should validate_presence_of(:state)}
  it { should validate_inclusion_of(:state).in_array(Article::VALID_STATES) }
  
  
  describe 'to_param' do
    it 'returns dasherized string' do
      @article.to_param.should eq "#{@article.id}-#{@article.title.downcase.split(' ').join('-')}"
    end
  end
  
  describe 'state_explanation' do
    it 'returns explanation for state' do
      Article.state_explanation['draft'].should eq Article::DRAFT_MESSAGE
    end
  end
  
  describe "Article.search" do
    before(:each) do
       @article = create(:article, title: 'Need help with your driver?')
       @article_2 = create(:article, title: "What to do when it all goes wrong with the driver")
       @article_3 = create(:article, title: 'Life of Tiger Woods')
     end
     
    it "returns [] when search nil" do
      result = Article.search("")
      result.should_not include(@article, @article_2, @article_3, subject)
      result.should eq []
    end
    
    it 'should return similar questions' do
      Article.search("driver").should include(@article, @article_2)
    end
     
    it 'should not return similar questions' do
      result = Article.search("chipping")
      result.should_not include(@article, @article_2, @article_3, subject)
      result.should eq []
    end
  end
  
  describe 'state machine' do
    before(:each) do 
      @article = create(:article)
    end
    
    context 'valid transitions' do
      context 'draft' do
        it 'transtions from submitted to draft' do
          @article.state = Article::SUBMITTED
          @article.draft
          @article.state.should eq Article::DRAFT
        end
        
        it 'transtions from approved to draft' do
          @article.state = Article::APPROVED
          @article.draft
          @article.state.should eq Article::DRAFT
        end
        
        it 'transtions from published to draft' do
          @article.published_at = Date.today
          @article.state = Article::PUBLISHED
          @article.draft
          @article.state.should eq Article::DRAFT
          @article.published_at.should be_nil
        end
        
        it 'transtions from discarded to draft' do
          @article.state = Article::DISCARDED
          @article.draft
          @article.state.should eq Article::DRAFT
        end
      end
        
      it 'transitions from draft to submitted' do
        @article.submit
        @article.state.should eq Article::SUBMITTED
      end
      
      it 'transitions from submitted to approved' do
        @article.state = Article::SUBMITTED
        @article.approve
        @article.state.should eq Article::APPROVED
      end
      
      it 'transitions from approved to published' do
        @article.state = Article::APPROVED
        @article.publish
        @article.reload
        @article.state.should eq Article::PUBLISHED
        @article.published_at.should eq Date.today
      end 
      
      context 'discard' do
        it 'transitions from draft to discarded' do
          @article.state = Article::DRAFT
          @article.discard
          @article.state.should eq Article::DISCARDED
        end
        
        it 'transitions from submitted to discarded' do
          @article.state = Article::SUBMITTED
          @article.discard
          @article.state.should eq Article::DISCARDED
        end
      end
    end
    
    context 'invalid transitions does not transition' do
      it 'from published to submitted' do
        @article.state = Article::PUBLISHED
        @article.submit
        @article.state.should_not eq Article::SUBMITTED
      end
      
      it 'from draft to draft' do
        @article.state = Article::DRAFT
        @article.draft
        @article.errors.full_messages.join.should include 'State cannot transition'
      end
      
      it 'from discarded to approved' do
        @article.state = Article::DISCARDED
        @article.approve
        @article.state.should_not eq Article::APPROVED
      end
      
      it 'from discarded to submitted' do
        @article.state = Article::DISCARDED
        @article.submit
        @article.state.should_not eq Article::SUBMITTED
      end
    end
  end
end