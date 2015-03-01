SlpContacts::Engine.routes.draw do
  resources :contacts, only: [:index]
end
