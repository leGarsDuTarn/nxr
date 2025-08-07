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

    # Route custom pour pouvoir recupérer la bonne URL pour le status des inscription et le dashboard#
    # Routes custom pour gérer la validation manuelle des inscriptions par l'admin
    # Ces routes ne sont pas imbriquées car elles concernent uniquement la logique métier du statutpatch "registrations/:id/validate",
    # to: "registration_validations#validate", as: :validate_admin_registration
    patch "registrations/:id/validate", to: "registration_validations#validate", as: :validate_admin_registration
    patch "registrations/:id/reject",   to: "registration_validations#reject",   as: :reject_admin_registration
    patch "registrations/:id/reset", to: "registration_validations#reset", as: :reset_admin_registration
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

  # path: ''  -> supprime le préfixe du namespace dans l’URL
  namespace :public, path: '' do
    resources :articles, only: [:index, :show]
    resources :galleries, only: [:index, :show]
  end
end
