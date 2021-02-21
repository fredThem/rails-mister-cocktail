Rails.application.routes.draw do
  # get 'cocktails/index'
  # get 'cocktails/create'
  # get 'cocktails/new'
  # get 'cocktails/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :cocktails, only: [:index, :create, :new, :show]
end
