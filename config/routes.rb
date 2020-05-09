Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  root 'static_pages#home'

  resources :posts, only: [:new, :create]
end
