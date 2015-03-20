Rails.application.routes.draw do
  get :login, to: 'sessions#new'

  mount SlpContacts::Engine => '/apps/contacts'

  root 'sessions#new'
end
