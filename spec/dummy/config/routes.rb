Rails.application.routes.draw do
  get :login, to: 'sessions#new'

  resources :namespaces, only: [] do
    mount SlpContacts::Engine => '/apps/contacts'
  end

  root 'sessions#new'
end
