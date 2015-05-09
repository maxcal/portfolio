Portfolio::Application.routes.draw do

  root to: 'pages#home'

  namespace :auth do
    get '/flickr/callback', to: 'callbacks#flickr'
    get '/failure', to: 'callbacks#failure'
  end
end
