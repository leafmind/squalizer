Rails.application.routes.draw do
  resources :users do
  	member do
      post :charge
  	end
    resources :reports
  end
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'oauth#failure'
  root 'sessions#new'
end
