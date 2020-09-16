Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  as :user do
    namespace :user do
      resources :bounties, only: [:index, :show]
    end
  end

  scope :auth do
    resource :users, except: :all do
      post :enter_email
    end
  end

  concern :votable do
    member do
      patch :vote_yes
      patch :vote_no
      patch :cancel_vote
    end
  end

  resources :questions, except: [:new, :edit], concerns: [:votable] do
    resources :answers, except: [:new, :edit], shallow: true, concerns: [:votable] do
      resources :comments, only: [:create], defaults: { commentable_type: 'answer' }

      member do
        patch :mark_as_the_best
      end
    end

    resources :comments, only: [:create], defaults: { commentable_type: 'question' }
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
