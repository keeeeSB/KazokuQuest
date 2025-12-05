Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }

  get 'up' => 'rails/health#show', as: :rails_health_check
end
