Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  },
  defaults: { format: :json }


  resources :tickets, param: :id do
    member do
      patch :close
      patch :reopen
      patch :assign
    end
  end

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check

end
