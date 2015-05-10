Portfolio::Application.routes.draw do

  root to: 'pages#home'

  namespace :auth do
    get '/flickr/callback', to: 'callbacks#flickr'
    get '/failure', to: 'callbacks#failure'
  end

  resources :users, only: [:show, :index, :edit, :update] do
    collection do
      resource :sessions, only: [:new, :destroy]
    end
  end

end
