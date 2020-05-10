Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#home'

  resources :users, only: [:show]
  resources :posts, only: [:new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
