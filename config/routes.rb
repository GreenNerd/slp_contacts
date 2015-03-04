SlpContacts::Engine.routes.draw do
  resources :users, only: [:show]
  resources :contacts, only: [:index]
end
