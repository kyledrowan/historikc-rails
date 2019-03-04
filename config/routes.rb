# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'locations#index'
  resources :locations, only: %i[index show]

  namespace :admin do
    root to: 'photos#index'
    resources :locations, :photos
    get 'logout' => 'logout#logout'
  end

  get 'auth/oauth2/callback' => 'auth0#callback'
  get 'auth/failure' => 'auth0#failure'
end
