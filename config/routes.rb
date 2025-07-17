Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :admin do
    resources :events do
      resources :registrations, only: [:index, :show, :destroy]
    end

    resources :races do
      resources :registrations, only: [:index, :show, :destroy]
    end

    resources :trainings do
      resources :registrations, only: [:index, :show, :destroy]
    end

    resources :articles
    resources :galleries
  end
end

  namespace :members do
    resources :events do
        resources :registrations, only: [:create, :new, :destroy]
      end

   resources :races do
        resources :registrations, only: [:create, :new, :destroy]
      end

    resources :trainings do
        resources :registrations, only: [:create, :new, :destroy]
      end

    resources :articles, only: [:index, :show]
    resources :galleries, only: [:index, :show]
end
