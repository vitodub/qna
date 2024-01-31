Rails.application.routes.draw do
  devise_for :users
  resources :users do
    member do
      get :rewards
    end
  end

  resources :questions, shallow: true do
    resources :answers, shallow: true do
      member do
        post 'mark_best'
        post 'like', defaults: { table: 'answers'}
        post 'dislike', defaults: { table: 'answers'}
        post 'comment', defaults: { table: 'answers'} 
      end
    end

    member do
      post 'like', defaults: { table: 'questions'}
      post 'dislike', defaults: { table: 'questions'}
      post 'comment', defaults: { table: 'questions'} 
    end  
  end

  root to: 'questions#index'

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  resources :links, only: :destroy
  resources :comments, only: :destroy
end
