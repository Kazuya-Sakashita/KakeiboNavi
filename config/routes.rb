Rails.application.routes.draw do
  root 'incomes#index'
  devise_for :users

  resources :users do
    resources :incomes
  end
end
