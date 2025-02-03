# frozen_string_literal: true

Rails.application.routes.draw do
  scope '/api/v1/tch' do
    resources :products, only: %i[show index update destroy] do
      collection do
        get 'above_average_price'
      end
    end
    resources :stores do
      get 'directions', on: :member
      resources :facilities, only: [:create]
    end

    resources :facilities, only: %i[show index update destroy]

    post 'sign_up', to: 'users#create'
    post 'login', to: 'users#login'
  end
end
