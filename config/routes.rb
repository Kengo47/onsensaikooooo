Rails.application.routes.draw do
  get 'users/show'
  get 'posts/new'
  get 'posts/create'
  get 'posts/destroy'
  devise_for :users
  root 'static_pages#home'
end
