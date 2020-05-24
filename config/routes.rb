Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users,
    path: '',
    path_names: {
      sign_up: '',
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    :controllers => {
      registrations: 'users/registrations',
      sessions: "users/sessions"
    }
  devise_scope :users do
    get 'signup', to: 'users/registrations#new'
  end

  resources :users, only: [:show]
  resources :posts, only: [:new, :show, :create, :edit, :update, :destroy] do
    collection do
      get :cities_select
    end
    resource :likes, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
end