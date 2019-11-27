Rails.application.routes.draw do
  devise_for :users

  resources :questions, except: [:new, :edit] do
    resources :answers, except: [:new, :edit], shallow: true do
      member do
        patch :mark_as_the_best
      end
    end
  end

  resources :files, only: [:destroy]

  root to: "questions#index"
end
