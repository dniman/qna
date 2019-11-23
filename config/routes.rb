Rails.application.routes.draw do
  devise_for :users

  resources :questions, except: [:new, :edit] do
    resources :answers, except: [:new, :edit], shallow: true do
      member do
        patch :mark_as_the_best
        delete :destroy_file_attachment
      end
    end
    member do
      delete :destroy_file_attachment
    end
  end

  root to: "questions#index"
end
