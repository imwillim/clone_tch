# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  describe 'GET /api/v1/tch/stores/:id/directions', type: :request do
    let(:directions_path) { "/api/v1/tch/stores/#{id}/directions" }
    let(:address) { '123 Main St' }
    let(:transportation) { 'driving' }
    let(:id) { 1 }
    let(:params) do
      {
        address:,
        transportation:,
        id:
      }
    end

    let(:directions_service) { instance_double(GetDirectionsService, directions_result) }
    let(:coordinate_service) { instance_double(GetUserCoordinatesService, coordinate_result) }

    context 'when request fails validation' do
      context 'when address is nil' do
        let(:address) { nil }
        it 'returns errors' do
          get(directions_path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body).to eq('errors' => 'address must be a string')
        end
      end
    end

    context 'when request fails' do
      let(:directions_result) do
        {
          error?: true,
          first_error: 'directions error'
        }
      end

      let(:coordinate_result) do
        {
          error?: true,
          first_error: 'coordinate error'
        }
      end
      before do
        allow(GetDirectionsService).to receive(:call).and_return(directions_service)
        allow(GetUserCoordinatesService).to receive(:call).and_return(coordinate_service)
      end

      it 'returns an error message' do
        get(directions_path, params:)

        expect(GetDirectionsService).not_to have_received(:call)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq('errors' => 'coordinate error')
      end
    end

    context 'when request succeeds' do
      let(:coordinate_result) do
        {
          error?: false,
          result: [80, 80]
        }
      end

      let(:result) do
        {
          duration: 10,
          distance: 100,
          steps: [
            'Turn right',
            'Turn left',
            'Your destination is on the right.'
          ]
        }
      end

      let(:directions_result) do
        {
          error?: false,
          result:
        }
      end

      before do
        allow(GetUserCoordinatesService).to receive(:call).and_return(coordinate_service)
        allow(GetDirectionsService).to receive(:call).and_return(directions_service)
      end

      it 'returns result of directions ' do
        get(directions_path, params:)

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data'].to_json).to eq(result.to_json)
      end
    end
  end

  describe 'GET /api/v1/tch/stores', type: :request do
    let(:path) { '/api/v1/tch/stores' }
    let(:days) { %w[Monday Tuesday] }

    describe '#validate' do
      let(:params) do
        {
          days:,
          open_hour:,
          close_hour:,
          address:
        }
      end

      context 'when parameters are not valid' do
        let(:days) { %w[invalid_days] }
        let(:open_hour) { 'not_valid' }
        let(:close_hour) { 'not_valid' }
        let(:address) { '' }

        let(:invalid_days) { '0 must be one of: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday' }
        let(:invalid_open_hour) { 'open_hour must be a time' }
        let(:invalid_close_hour) { 'close_hour must be a time' }
        let(:empty_address) { 'address must be filled' }

        it 'returns 400 response' do
          get(path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors'])
            .to eq("#{invalid_days}, #{invalid_open_hour}, #{invalid_close_hour}, #{empty_address}")
        end
      end

      context 'when close_hour is less than open_hour' do
        let(:close_hour) { '20:00' }
        let(:open_hour) { '21:00' }
        let(:params) do
          {
            open_hour:,
            close_hour:
          }
        end

        it 'returns 400 response' do
          get(path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors']).to eq('close_hour cannot be less than open_hour')
        end
      end
    end

    describe 'when request succeeds' do
      let!(:store) { create(:store) }
      let!(:working_hour) { create(:working_hour, store_id: store.id) }

      let(:days) { %w[Monday] }
      let(:params) { :days }

      context 'when request does not have parameters' do
        let!(:another_store) { create(:store) }
        let!(:another_working_hour) { create(:working_hour, store_id: another_store.id) }

        let(:expected_result) do
          [
            {
              'id' => store.id,
              'name' => store.name,
              'working_hours' => [{
                'id' => working_hour.id,
                'day' => 'Monday',
                'open_hour' => '09:30',
                'close_hour' => '22:00'
              }]
            },
            {
              'id' => another_store.id,
              'name' => another_store.name,
              'working_hours' => [{
                'id' => another_working_hour.id,
                'day' => 'Monday',
                'open_hour' => '09:30',
                'close_hour' => '22:00'
              }]
            }
          ]
        end

        it 'returns all stores' do
          get(path, params:)

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.to_json).to eq(expected_result.to_json)
        end
      end

      context 'when request filters a day' do
        let(:expected_result) do
          [{
            'id' => store.id,
            'name' => store.name,
            'working_hours' => [{
               'id' => working_hour.id,
               'day' => 'Monday',
               'open_hour' => '09:30',
               'close_hour' => '22:00'
             }]
          }]
        end

        it 'returns stores' do
          get(path, params:)

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(expected_result)
        end
      end

      context 'when request filters open_hour' do
        let!(:working_hour) { create(:working_hour, store_id: store.id, open_hour:) }
        let(:open_hour) { '6:00' }
        let(:params) { :open_hour }

        let(:expected_result) do
          [{
            'id' => store.id,
            'name' => store.name,
            'working_hours' => [{
               'id' => working_hour.id,
               'day' => 'Monday',
               'open_hour' => '06:00',
               'close_hour' => '22:00'
             }]
          }]
        end

        it 'returns stores' do
          get(path, params:)

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(expected_result)
        end
      end

      context 'when request filters close_hour' do
        let!(:working_hour) { create(:working_hour, store_id: store.id, close_hour:) }
        let(:close_hour) { '21:00' }
        let(:params) { :close_hour }

        let(:expected_result) do
          [{
            'id' => store.id,
            'name' => store.name,
            'working_hours' => [{
               'id' => working_hour.id,
               'day' => 'Monday',
               'open_hour' => '06:00',
               'close_hour' => '21:00'
             }]
          }]
        end
      end
    end
  end
end
