Rails.application.routes.draw do
  get "dashboard/index"
  get "drink_logs/index"
  get "drink_logs/new"
  get "drink_logs/edit"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get "home", to: "pages#home"
  get "account", to: "pages#account"
  get "dashboard", to: "dashboard#index"
  get "terms",   to: "pages#terms"
  get "privacy", to: "pages#privacy"
  get "guide", to: "pages#guide"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
}

  resources :drink_records, only: %i[index]
  post "drink_records/quick_create", to: "drink_records#quick_create", as: :quick_create_drink_records
  resources :drink_logs, only: %i[index new create edit update destroy]

  resources :drinks do
    resources :drink_records, only: %i[new create edit update destroy]
    resources :drink_logs, only: %i[new create edit update destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root to: "pages#home"

  namespace :admin do
    root "dashboard#index"
    resources :users, only: [ :index ]
    resources :drinks, only: [ :index ]
    resources :drink_records, only: [ :index ]
  end
end
