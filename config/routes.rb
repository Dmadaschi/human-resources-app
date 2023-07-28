Rails.application.routes.draw do
  root "pages#index"

  namespace :api do
    namespace :v1 do
      resources :employees, only: %i[index create update]
      resources :vacations, only: %i[index create update show destroy]
    end
  end
end
