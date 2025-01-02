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
    end
    resources :categories do
      get 'toppings', on: :member
      get 'sizes', on: :member
    end
  end
end
