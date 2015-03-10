SlpContacts::Engine.routes.draw do
  match '/', to: 'users#show', via: :get
  match '/favorite', to: 'contacts#index', via: :get  
  resources :users, only: [:show] do
    member do
      post :favorite
      delete :unfavorite
    end
  end
  resources :contacts, only: [:index]
  resources :organizations, only: [:index, :show]
end
