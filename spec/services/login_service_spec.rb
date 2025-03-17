# frozen_string_literal: true

require 'rails_helper'

describe LoginService do
  subject(:service) { described_class.new(safe_params) }

  let!(:user) { create(:user, email:, password:, password_confirmation:) }
  let(:email) { 'abc@email.com' }
  let(:password) { '123' }
  let(:password_confirmation) { password }

  let(:safe_params) do
    {
      email:,
      password:
    }
  end

  describe '#validate' do
    context 'when email is not found' do
      let(:safe_params) do
        {
          email: 'a',
          password: '123'
        }
      end

      it 'fails validation' do
        service.call

        expect(service.success?).to eq false
        expect(service.first_error.message).to eq 'Login failed! Please check email or password'
      end
    end

    context 'when password does not match' do
      let(:safe_params) do
        {
          email: 'abc@email.com',
          password: '12'
        }
      end

      it 'fails validation' do
        service.call

        expect(service.success?).to eq false
        expect(service.first_error.message).to eq 'Login failed! Please check email or password'
      end
    end
  end

  describe '#call' do
    let(:token) { 'header.payload.signature' }

    before do
      allow(JsonWebTokenManager).to receive(:encode).and_return(token)
    end

    let(:safe_params) do
      {
        email: 'abc@email.com',
        password: '123'
      }
    end

    it 'returns the result' do
      service.call

      expect(service.success?).to be true
      expect(service.result).to eq(token)
    end
  end
end
