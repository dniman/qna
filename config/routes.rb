Rails.application.routes.draw do
  devise_for :users

  resources :questions, except: [:new, :edit] do
    resources :answers, except: [:new, :edit, :show], shallow: true do
      member do
        patch :mark_as_the_best
      end
    end
  end

  root to: "questions#index"
end
