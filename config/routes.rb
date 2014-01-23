Eajobsboard::Application.routes.draw do
	resources :users
	resources :jobs
	match '/signup', to: 'users#new', via: 'get'
	root 'jobs#index'
end
