class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new #not logged in
    
    if user.admin?
      
      # Admins can do everything
      can :manage, :all
      
    elsif user.role == 'standard'
      
      # Logged in users can read pretty much everything
      
      # Questions
      can [:new, :create, :popular, :unanswered, :read,  :related], Question
      can [:update, :edit, :destroy, :correct], Question do |question|
        question.try(:user) == user
      end
      
      # Articles
      can [:new, :create, :read], Article
      can [:edit, :update, :destroy, :draft, :submit, :discard], Article do |article|
        article.try(:user) == user
      end
      
      # Answers
      can [:new, :create,  :correct, :read], Answer
      can [:update, :destroy, :edit, :correct], Answer do |answer|
        answer.try(:user) == user
      end
      
      # Comments
      can [:new, :create,  :read], Comment
      can [:destroy], Comment do |comment| 
        comment.try(:user) == user
      end
      
      # Votes
      can [:new, :create], Vote
      
      # Videos
      can [:new, :create], Video
      can [:destroy, :read, :edit, :update], Video do |video|
        video.try(:user) == user
      end
      
      # Points
      can [:breakdown], Point do |point|
        point.try(:user) == user
      end
      
      # Users
      can [:articles, :questions, :answers], User do |user|
        user == user
      end
      
      # Tags
      can [:read, :question_tags], Tag    
    else
      can [:popular, :unanswered, :read, :related], Question
      can [:index, :show], Article
      can [:index], Comment
      can [:show], Answer
      can [:index], User
    end
  end
end
