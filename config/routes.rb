Rails.application.routes.draw do
  devise_for :users
  resources :documents
  resources :operations, only: :create
  root "documents#index"
end
