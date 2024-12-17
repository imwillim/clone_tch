# frozen_string_literal: true

Rails.application.routes.draw do
  scope '/api/v1/tch' do
    resources :products, only: %i[show index update destroy]
    resources :stores do
      get 'directions', on: :member
    end

    resources :facilities, only: %i[show index update destroy]
  end
end
