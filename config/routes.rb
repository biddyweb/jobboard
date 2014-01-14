Eajobsboard::Application.routes.draw do
	resources :jobs
	root 'jobs#index'
end
