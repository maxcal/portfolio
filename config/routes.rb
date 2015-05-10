Portfolio::Application.routes.draw do

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
end
