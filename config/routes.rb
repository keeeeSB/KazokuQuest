Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }
  devise_for :users, controllers: {
    sessions: 'users/sessions',
  }

  namespace :admins do
    root 'static_pages#home'
    resources :tasks, only: %i[index show new edit create update destroy]
  end

  namespace :users do
    resources :works, only: %i[show new edit create update destroy]
    resource :daily_record, only: %i[show]
  end

  resource :family, only: %i[show new edit create update] do
    resource :daily_record, only: %i[show], module: :families
  end

  root 'families/daily_records#show'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'up' => 'rails/health#show', as: :rails_health_check
end
