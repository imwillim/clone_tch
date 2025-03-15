# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersController', type: :controller do
  describe 'POST /api/v1/tch/sign_up', type: :request do
    let(:email) { 'email' }
    let(:password) { '' }
    let(:password_confirmation) { 'passw' }
    let(:api_path) { '/api/v1/tch/sign_up' }
    let(:body) do
      {
        email:,
        password:,
        password_confirmation:
      }
    end

    context 'when request fails validation' do
      context 'when missing required fields' do
        it 'returns errors' do
          post(api_path)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body).to eq('errors' => 'email is missing, password is missing,
password_confirmation is missing')
        end
      end
    end

    context 'when request succeeds' do
      let(:email) { 'email@email.com' }
      let(:password) { 'password' }
      let(:password_confirmation) { 'password' }

      it 'returns created response' do
        post(api_path, params: body)

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to eq('message' => 'User created successfully')

        expect(User.count).to eq(1)
      end
    end
  end

  describe 'POST /api/v1/tch/login', type: :request do
    let(:email) { 'user@email.com' }
    let(:password) { 'password' }
    let!(:user) { User.create(email:, password:) }

    let(:api_path) { '/api/v1/tch/login' }
    let(:body) do
      {
        email: user.email,
        password: user.password
      }
    end

    let(:token) { 'token' }
    let(:params) do
      {
        email: user.email,
        password: user.password
      }
    end

    context 'when sign in succeeds' do
      let(:service_result) do
        {
          success?: true,
          result: token
        }
      end

      let(:login_service) { instance_double(LoginService, service_result) }

      before do
        allow(LoginService).to receive(:call).and_return(login_service)
      end

      it 'returns token' do
        post(api_path, params: body)

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']).to eq('token' => 'token')
      end
    end

    context 'when sign in fails' do
      let(:service_result) do
        {
          success?: false,
          first_error: 'Login failed! Please check email or password'
        }
      end

      let(:login_service) { instance_double(LoginService, service_result) }

      before do
        allow(LoginService).to receive(:call).and_return(login_service)
      end

      it 'returns error' do
        post(api_path, params: body)

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq('error' => 'Login failed! Please check email or password')
      end
    end
  end

  describe 'POST /api/v1/tch/sign_out', type: :request do
    let(:email) { 'user@email.com' }
    let(:password) { 'password' }
    let!(:user) { User.create(email:, password:) }

    let(:api_path) { '/api/v1/tch/sign_out' }
    let(:token) { 'valid_token' }
    let(:headers) { { 'Authorization' => token.to_s } }
    let(:duration) { 10.minutes.to_i }

    context 'when token is valid' do
      before do
        allow_any_instance_of(UsersController).to receive(:authenticate_token) do |controller|
          controller.instance_variable_set(:@current_user, user)
        end

        allow(CacheManager).to receive(:assign_value).with("black_list #{token}", '', duration)
      end

      it 'logs out successfully' do
        post(api_path, headers: headers)

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq('data' => { 'message' => 'Logout successfully' })
        expect(CacheManager).to have_received(:assign_value).with("black_list #{token}", '', duration)
      end
    end

    context 'when token is missing or invalid' do
      let(:headers) { {} }

      it 'returns unauthorized' do
        post(api_path, headers: headers)

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body).to eq('errors' => 'Unauthorized')
      end
    end
  end
end
