Eajobsboard::Application.routes.draw do
	resources :jobs
	resources :users, only: [:new, :create, :destroy]
	resources :sessions, only: [:new, :create, :destroy]
	root 'jobs#index'

	match '/signup', to: 'users#new', via: 'get'
	match '/signin', to: 'sessions#new', via: 'get'
	match '/signout', to: 'sessions#destroy', via: 'delete'
end
