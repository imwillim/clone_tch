# frozen_string_literal: true

Rails.application.routes.draw do
  scope '/api/v1/tch' do
    resources :products, only: %i[show index]
    resources :stores do
      get 'directions', on: :member
    end
  end
end
