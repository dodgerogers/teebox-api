FactoryGirl.define do
  factory :user do |u|
    u.sequence(:email) {|n| "test#{n}@hotmail.com"}
    u.sequence(:username) {|n| "tester#{n}" }
    u.password "password"
    u.password_confirmation "password" 
    u.remember_me true
    u.reputation 200
    u.role "admin"
    u.notifications "1"
  end
  
  factory :article do
    title 'How to reduce sidespin'
    body 'Nulla ac fringilla lectus. Sed quis dictum urna. Duis pretium metus felis, id gravida tortor faucibus eget. Quisque varius pulvinar leo'
    cover_image 'an_image.jpg'
    user
    state 'draft'
    published_at nil
  end
  
  factory :question do 
    title "slicing the ball"
    body "i cut across the ball"
    user
    youtube_url "http://youtube.com"
    answers_count 5
    votes_count 5
    correct false
  end    
  
  factory :video do
    user
    name 'Swing in HK'
    duration 10
    location 'Hong Kong'
    file "http://#{CONFIG[:s3_bucket]}.s3.amazonaws.com/uploads/video/file/22120817-19bf-40ec-96f1-3c904772370b/3-wood-creamed.m4v"
    screenshot "https://#{CONFIG[:s3_bucket]}.s3.amazonaws.com/uploads/video/screenshot/73/3-wood-creamed.m4v.jpg"
    job_id "1395783182474-246e34"
    status "Submitted"
  end
  
  factory :playlist do
    question_id :question
    video_id :video
  end
  
  factory :comment do
    user
    commentable_id :question
    commentable_type "Question"
    content "this is a useful comment"
    votes_count 5
  end
  
  factory :answer do
    user
    question_id :question
    body "you need to change your grip"
    votes_count 0
    correct false
  end
  
  factory :vote do
    user
    votable_id :answer
    votable_type "Answer"
    value 1
    points 5
  end
  
  factory :question_vote, parent: :vote do
    user
    votable_id :question
    votable_type "Question"
    value 1
    points 5
  end
  
  factory :comment_vote, parent: :vote do
    user
    votable_id :comment
    votable_type "Comment"
    value 1
    points 5
  end
  
  factory :point do
    user
    pointable_id :vote
    pointable_type "Vote"
    value 5
  end  
  
  factory :tag do
    name "slice"
    explanation "ball curves from left to right"
    updated_by "Andy"
  end
  
  factory :tagging do
    tag_id :tag
    question_id :question
  end
  
  factory :activity do
     trackable_id :answer
     recipient_id :user
     owner_id :user
  end
  
  factory :report do
    answers 1
    answers_total 1
    questions 1
    questions_total 1
    users 2
    users_total 2
  end
  
  factory :impression do
    impressionable_id :question
    impressionable_type "Question"
    ip_address "127.0.0.1"
  end
  
  factory :social, class: Statistics::Social do
    likes 10
    followers 400
  end
end