Rails.application.routes.draw do
  
  namespace :api, defaults: { format: 'json' }  do
    root to: "questions#index"
    resources :questions, except: [:new, :edit]
    resources :answers, except: [:new, :edit]
    resources :comments, except: [:new, :edit]
    resources :users, except: [:new, :edit]
    
    get "search", to: 'search#index', as: :search
  end
end
