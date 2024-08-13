# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:tea_category) { create(:category) }
  let(:tea) { create(:product, category: tea_category) }
  let(:error_message) { 'Product not found' }

  let(:product_result) { instance_double(GetProductService, success?: true, result: tea) }
  let(:product_failure) do
    instance_double(GetProductService, success?: false, first_error: instance_double('Error', message: error_message))
  end

  let(:products) do
    {
      name: tea_category.name,
      products: [
        id: tea.id,
        name: tea.name,
        price: tea.price,
        thumbnail: tea.thumbnail,
        tag: {
          name: nil,
          color: nil
        }
      ]
    }
  end
  let(:products_result) { instance_double(GetProductsService, success?: true, result: products) }
  let(:products_failure) do
    instance_double(GetProductsService, success?: false, first_error: instance_double('Error', message: error_message))
  end

  describe 'GET #index' do
    context 'when category_id is invalid' do
      it 'returns expected response' do
        get :index, params: { category_id: 'invalid-uuid-format' }

        expect(response.status).to eq 400
        expect(response.parsed_body).to eq('errors' => 'category_id is not a valid UUID')
      end
    end

    context 'when category_id is valid' do
      let(:expected_data) do
        {
          data: {
            name: tea_category.name,
            products: [
              {
                id: tea.id,
                name: tea.name,
                price: tea.price,
                thumbnail: tea.thumbnail,
                tag: {
                  name: nil,
                  color: nil
                }
              }
            ]
          }
        }
      end
      before do
        allow(GetProductsService).to receive(:call).with(tea_category.id).and_return(products_result)
      end

      it 'renders products successfully' do
        get :index, params: { category_id: tea_category.id }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.to_json).to eq(expected_data.to_json)
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
          let(:expected_data) do
            {
              'data' => {
                'id' => tea.id,
                'name' => tea.name,
                'description' => tea.description,
                'price' => tea.price.to_s,
                'image_urls' => tea.image_urls,
                'sizes' => [],
                'tag' => nil,
                'toppings' => []
              }
            }
          end

          before do
            allow(GetProductService).to receive(:call).with(tea.id).and_return(product_result)
          end

          it 'renders the product successfully' do
            get :show, params: { id: tea.id }

            expect(response).to have_http_status(:ok)
            expect(response.parsed_body).to eq(expected_data)
          end
        end

        context 'when request call fails' do
          let(:random_id) { SecureRandom.uuid }

          before do
            allow(GetProductService).to receive(:call).with(random_id).and_return(product_failure)
          end

          let(:expected_error) do
            {
              'message' => error_message
            }
          end

          it 'renders an error message' do
            get :show, params: { id: random_id }

            expect(response.status).to eq 422
            expect(response.parsed_body).to eq(expected_error)
          end
        end
      end
    end
  end
end
