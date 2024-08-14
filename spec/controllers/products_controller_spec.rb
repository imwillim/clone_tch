# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:tea_category) { create(:category) }
  let(:tea) { create(:product, category: tea_category) }

  describe 'GET #index' do
    context 'when category_id is invalid' do
      it 'returns expected response' do
        get :index, params: { category_id: 'invalid-uuid-format' }

        expect(response.status).to eq 400
        expect(response.parsed_body).to eq('errors' => 'category_id is not a valid UUID')
      end
    end

    context 'when category_id is valid' do
      let(:service_result) { instance_double(GetProductService, success?: true, result: tea) }

      before do
        allow(GetProductsService).to receive(:call).with(tea_category.id).and_return(service_result)
      end

      it 'renders products successfully' do
        get :index, params: { category_id: tea_category.id }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']).to be_present
      end
    end
  end

  describe 'GET #show' do
    context 'when product_id is invalid' do
      it 'returns expected response' do
        get :show, params: { id: 'invalid-uuid-format' }

        expect(response.status).to eq 400
        expect(response.parsed_body).to eq('errors' => 'id is not a valid UUID')
      end
    end

    context 'when product_id is valid' do
      context 'when request call is successful' do
        let(:service_result) { instance_double(GetProductService, success?: true, result: tea) }

        before do
          allow(GetProductService).to receive(:call).with(tea.id).and_return(service_result)
        end

        it 'renders the product successfully' do
          get :show, params: { id: tea.id }

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body['data']).to be_present
        end
      end

      context 'when request call fails' do
        let(:random_id) { SecureRandom.uuid }
        let(:service_failure) do
          instance_double(GetProductService, success?: false, first_error: StandardError.new('product not found'))
        end

        before do
          allow(GetProductService).to receive(:call).with(random_id).and_return(service_failure)
        end

        it 'renders an error message' do
          get :show, params: { id: random_id }

          expect(response.status).to eq 422
          expect(response.parsed_body).to eq({ 'message' => 'product not found' })
        end
      end
    end
  end
end
