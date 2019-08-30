Rails.application.routes.draw do
  resources :products, only: %i[index show destroy create update], format: :json
end
