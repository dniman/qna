Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true
  end

  resources :answers do
    member do
      patch :mark_as_the_best
    end
  end
  
  root to: "questions#index"
end
