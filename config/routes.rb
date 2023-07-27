Rails.application.routes.draw do
  root "pages#index"

  namespace :api do
    namespace :v1 do
      resources :employees, only: %i[index create update]
    end
  end
end
