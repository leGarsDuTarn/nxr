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
    # Pour pouvoir avoir une gestion des membres et pouvoir se conformer au RGPD
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      # Route qui permet l'export des données personnelles des utilisateurs - conforme RGPD
      member do
        get :export
      end
    end

    get "dashboard", to: "dashboard#index"
  end


  namespace :members do
    resources :events, only: [:index, :show] do
        resources :registrations, only: [:show, :create, :new, :destroy, :edit, :update]
      end

   resources :races, only: [:index, :show] do
        resources :registrations, only: [:show, :create, :new, :destroy, :edit, :update]
      end

    resources :trainings, only: [:index, :show] do
        resources :registrations, only: [:show, :create, :new, :destroy, :edit, :update]
      end

    resources :articles, only: [:index, :show]
    resources :galleries, only: [:index, :show]
    get "dashboard", to: "dashboard#index"
  end
end
