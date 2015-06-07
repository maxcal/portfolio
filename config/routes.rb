Portfolio::Application.routes.draw do

  resources :pages

  namespace :site do
    resources :configurations
  end

  root to: 'pages#home'

  namespace :auth do
    get '/flickr/callback', to: 'callbacks#flickr'
    get '/failure', to: 'callbacks#failure'
  end

  resources :users, except: [:new] do
    collection do
      resource :sessions, only: [:new, :destroy]
    end
  end

  resources :photosets do
    member do
      patch :refresh
    end
  end
end