# frozen_string_literal: true

Rails.application.routes.draw do
  scope '/api/v1/tch' do
    resources :products, only: [:show]
  end
end
