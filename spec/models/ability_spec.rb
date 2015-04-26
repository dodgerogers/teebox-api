require "spec_helper"
require "cancan/matchers"

describe "Abilities" do
  describe "non signed in user" do
    it "can view static pages" do
      ability = Ability.new(User.new)
      
      [:popular, :unanswered, :read, :related].each do |action|
        ability.should be_able_to(action, Question)
      end
      
      ability.should be_able_to(:index, Comment)
      ability.should be_able_to(:show, Answer)
    end
  end
  
  describe "admin user" do
    it "can manage all questions" do
      user = create(:user, role: 'admin')
      ability = Ability.new(user)
      
      ability.should be_able_to(:manage, :all)
    end
  end
  
  describe "standard user" do
    before(:each) do
      @user1 = create(:user, role: 'standard')
      @user2 = create(:user, role: 'standard')
      @ability = Ability.new(@user1)
      @question = attributes_for(:question, user_id: @user1.id)
    end
    
    context "cannot manage" do
      it "other people's questions" do
        @ability.should_not be_able_to(:manage, Question.new)
      end
  
      it "other people's answers" do
        @ability.should_not be_able_to(:manage, Answer.new)
      end
      
      it "other people's answers" do
        @ability.should_not be_able_to(:manage, Comment.new)
      end
      
      it "other people's answers" do
        @ability.should_not be_able_to(:manage, Video.new)
      end
      
      it "other people's answers" do
        @ability.should_not be_able_to(:manage, Tag.new)
      end
    end
  end
end