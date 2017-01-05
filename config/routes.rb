Rails.application.routes.draw do
  resources :sessions do
    collection do
      get :failure
    end
  end
  resources :users do
  	member do
      post :charge
  	end
    resources :reports
  end
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  root 'sessions#new'
end
