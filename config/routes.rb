SlpContacts::Engine.routes.draw do
  resources :users, only: [:show]
  resources :contacts, only: [:index]
  resources :organizations, only: [:index, :show]
end
