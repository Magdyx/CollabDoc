Rails.application.routes.draw do
  devise_for :users
  resources :documents do
    resources :documents_users, only: [:new, :create, :destroy, :index]
  end
  resources :operations, only: :create
  root "documents#index"
end
