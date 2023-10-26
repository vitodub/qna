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
        post 'like', defaults: { votable_table: 'answers'}
        post 'dislike', defaults: { votable_table: 'answers'} 
      end
    end

    member do
      post 'like', defaults: { votable_table: 'questions'}
      post 'dislike', defaults: { votable_table: 'questions'} 
    end  
  end

  root to: 'questions#index'

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  resources :links, only: :destroy
end
