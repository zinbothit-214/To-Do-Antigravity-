Rails.application.routes.draw do
  devise_for :users
  
  resources :departments do
    member do
      get :tasks
    end
  end
  
  resources :tasks do
    member do
      patch :assign
    end
    resources :comments, only: [:create]
  end
  
  root 'tasks#index'
  
  # Add some useful routes for dashboard
  get 'dashboard', to: 'tasks#dashboard'
  get 'my_tasks', to: 'tasks#my_tasks'
end
