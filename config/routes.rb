Rails.application.routes.draw do
  devise_for :users
  as :user do
    namespace :user do
      resources :bounties, only: [:index, :show]
    end
  end

  resources :questions, except: [:new, :edit] do
    resources :answers, except: [:new, :edit], shallow: true do
      member do
        patch :mark_as_the_best
      end
    end
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]

  root to: "questions#index"
end
