Rails.application.routes.draw do
  devise_for :users
  resources :users do
    member do
      get :rewards
    end
  end

  resources :questions do
    resources :answers, shallow: true, except: %i[ show index ] do
      member do
        post 'mark_best'
      end
    end  
  end

  root to: 'questions#index'

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  resources :links, only: :destroy
end
