require "sidekiq/web"

Rails.application.routes.draw do
  authenticate :user, lambda{|u| u.admin?} do
    mount Sidekiq::Web => "/sidekiq"
  end

  use_doorkeeper
 
  namespace :api do
    namespace :v1 do
      resource :profiles, only: [] do
        get :me, on: :collection
        get :others, on: :collection
      end

      resources :questions, except: [:new, :edit] do
        resources :answers, except: [:new, :edit], shallow: true
      end
    end
  end
  
  
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
    
    member do
      post :subscribe, to: 'subscriptions#create', as: 'subscribe'
      delete :unsubscribe, to: 'subscriptions#destroy', as: 'unsubscribe'
    end
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
