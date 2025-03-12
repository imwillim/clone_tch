# frozen_string_literal: true

class UsersController < ApplicationController
  EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

  schema(:create) do
    required(:email).value(format?: EMAIL_REGEX)
    required(:password).value(:string)
    required(:password_confirmation).value(:string)

    optional(:phone).value(:string)
    optional(:address).value(:string)
  end

  def create
    User.create!(email: safe_params[:email],
                 password: safe_params[:password],
                 password_confirmation: safe_params[:password_confirmation],
                 phone: safe_params[:phone],
                 address: safe_params[:address])

    render json: { message: 'User created successfully' }, status: :created
  end

  schema(:login) do
    required(:email).value(format?: EMAIL_REGEX)
    required(:password).value(:string)
  end

  def login
    service = LoginService.call(safe_params)

    if service.success?
      render json: { data: { token: service.result } }, status: :ok
    else
      render json: { error: service.first_error }, status: :bad_request
    end
  end

  before_action :authenticate_token, only: [:logout]

  def logout
    token = request.headers['Authorization']

    CacheManager.assign_value("black_list #{token}", @current_user.id)

    render json: { data: { message: 'Logout successfully' } }, status: :ok
  end
end
