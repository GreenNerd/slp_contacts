SlpContacts::Engine.routes.draw do
  resources :users, only: [:show] do
    member do
      post :favorite
    end
  end
  resources :contacts, only: [:index]
  resources :organizations, only: [:index, :show]
end
