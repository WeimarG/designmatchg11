Rails.application.routes.draw do
  get 'designs/index'

  get 'designs/create'

  get 'services/index'

  root to: 'home#index'

  get '/company/:slug', to: 'projects#index', as: :company
  get '/company/:slug/designs/new/:id', to: 'designs#new', as: :new_design
  post '/company/:slug/designs/new/:id', to: 'designs#create'
  get '/design/download', to: 'designs#download'

  resources :users
  resources :sessions
  resources :projects
  resources :services 
end
