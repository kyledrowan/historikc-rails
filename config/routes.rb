Rails.application.routes.draw do
  root to: 'locations#index'
  resources :locations, only: [:index, :show]

  if Rails.env.development?
	  namespace :admin do
	    root to: 'locations#index'
	    resources :locations, :photos
	  end
	end
end
