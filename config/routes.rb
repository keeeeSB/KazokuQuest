Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }

  namespace :admins do
    root 'static_pages#home'
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
