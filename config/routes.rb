Rails.application.routes.draw do
  devise_for :users
  as :user do
    namespace :user do
      resources :bounties, only: [:index, :show]
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
      member do
        patch :mark_as_the_best
      end
    end
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]

  root to: "questions#index"
end
