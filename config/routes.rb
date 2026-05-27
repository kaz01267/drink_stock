Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get "home", to: "pages#home"
  get "account", to: "pages#account"
  get "terms",   to: "pages#terms"
  get "privacy", to: "pages#privacy"
  get "guide", to: "pages#guide"

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :drink_records, only: %i[index]

  resources :drinks do
    resources :drink_records, only: %i[new create edit update destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root to: "pages#home"
end
