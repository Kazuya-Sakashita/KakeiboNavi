# frozen_string_literal: true

Rails.application.routes.draw do
  root 'incomes#index'
  devise_for :users

  resources :users do
    resources :incomes
    resources :expenses
    resources :reports, only: [:index, :show]
  end
end
