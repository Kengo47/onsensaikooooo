Rails.application.routes.draw do
  devise_for :users,
    path: '',
    path_names: {
      sign_up: '',
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    :controllers => {
      :registrations => 'users/registrations',
      sessions: "users/sessions"
    }
  devise_scope :users do
    get 'signup', to: 'users/registrations#new'
  end
  root 'static_pages#home'

  resources :users, only: [:show]
  resources :posts, only: [:new, :show, :create, :edit, :update, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
end