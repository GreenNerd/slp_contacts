SlpContacts::Engine.routes.draw do
  get '/', to: 'users#show'
  get '/favorites', to: 'contacts#index'  
  get '/favorites/query', to: 'contacts#query'
  get '/query', to: 'users#query'
  get '/organizations/:id/members', to: 'organizations#show'
  resources :users, only: [:show] do
    member do
      post :favorite
      delete :unfavorite
    end
  end
  resources :contacts, only: [:index]
  resources :organizations, only: [:index] do
    member do
      get :query
    end
  end
  
end
