Rails.application.routes.draw do
  devise_for :users, path_prefix: 'api'
  match '(errors)/:status', to: 'errors#show', constraints: { status: /\d{3}/ }, via: :all
    
  namespace :api, defaults: { format: 'json' }  do
     
    root to: "questions#index"
    
    resources :users, only: [:show, :index]
    get "users/:id/questions", to: "users#questions", as: :user_questions
    get "users/:id/answers", to: "users#answers", as: :user_answers
    get "users/:id/articles", to: "users#articles", as: :user_articles
    
    resources :questions, except: [:new, :edit]
    
    resources :comments, except: [:new, :edit]
    
    resources :users, except: [:new, :edit]
    
    resources :videos, except:[:new, :edit]
    
    resources :votes, only: [:create]
    
    resources :reports, only: [:index, :create, :destroy]
    
    resources :signed_urls, only: :index
    
    resources :answers, except: [:new, :edit] do
      member { put :correct }
    end
    
    resources :points, only: :index do
      collection { get :breakdown }
    end
    
    resources :articles do
      member { put *[:draft, :submit, :approve, :publish, :discard] }
    end
    get 'admin/articles', to: 'articles#admin', as: :admin_articles
      
    resources :activities, only: [:index] do
      member { put :read }
    end
    
    resources :tags
    get "question_tags", to: "tags#question_tags", as: :question_tags #tokenInput json tags
    
    get "search", to: 'search#index', as: :search
    
    post "/aws/end_point", to: 'aws_notifications#end_point', as: :end_point
  end
end

# devise_for :users, :path_prefix => 'api/v1', skip: :all
# 
#   namespace :api do
#       devise_scope :user do
#         post 'login' => 'sessions#create', :as => :login
#         delete 'logout' => 'sessions#destroy', :as => :logout
#         post 'register' => 'registrations#create', :as => :registers
#         delete 'delete_account' => 'registrations#destroy', :as => :delete_account
#         post 'reconfirm_account' => 'confirmations#create', :as => :reconfirm
#         get 'confirm_account' => 'confirmations#show', :as => :confirmation
