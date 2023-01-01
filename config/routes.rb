Rails.application.routes.draw do

  root 'pages#home'

  devise_for :users,
              path: '',
              path_names: {sign_up: 'register', sign_in: 'login', edit: 'profile', sign_out: 'logout'},
              controllers: {registrations: 'registrations'}

  get 'pages/home'
  get '/dashboard', to: 'users#dashboard'
  get '/users/:id', to: 'users#show', as: 'user'

  post '/users/edit', to: 'users#update'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
