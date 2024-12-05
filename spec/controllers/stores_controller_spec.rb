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
          address:,
          city_code:
        }
      end

      context 'when parameters are not valid' do
        let(:days) { %w[invalid_days] }
        let(:open_hour) { 'not_valid' }
        let(:close_hour) { 'not_valid' }
        let(:address) { '' }
        let(:city_code) { 'not_valid' }

        let(:invalid_days) { '0 must be one of: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday' }
        let(:invalid_open_hour) { 'open_hour must be a time' }
        let(:invalid_close_hour) { 'close_hour must be a time' }
        let(:empty_address) { 'address must be filled' }
        let(:invalid_city_code) { 'city_code must be one of: HCM, HN' }

        it 'returns 400 response' do
          get(path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors'])
            .to eq("#{invalid_days}, #{invalid_open_hour}, #{invalid_close_hour}, #{empty_address}, #{invalid_city_code}")
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
      let(:city) { create(:city) }
      let!(:address) { create(:address, city:, store: store1) }
      let!(:address2) { create(:address, city:, store: store2) }
      let!(:working_hours) { create(:working_hour, store: store1) }
      let!(:working_hours2) { create(:working_hour, store: store2) }
      let(:store1) { create(:store) }
      let(:store2) { create(:store) }

      let(:params) { {} }

      context 'when request does not have parameters' do
        it 'returns all stores' do
          get(path, params:)
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.pluck('id')).to match_array([store1.id, store2.id])
        end
      end

      context 'when request filters by day' do
        let(:days) { %w[Monday] }

        before do
          params.update({ days: })
          working_hours.update(day: 'Sunday')
        end

        it 'returns stores' do
          get(path, params:)

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.pluck(:id)).to match_array([store2.id])
        end
      end

      context 'when request filters by open_hour' do
        let(:open_hour) { '10:00' }

        before do
          working_hours.update(open_hour:)
          params.update({ open_hour: })
        end

        it 'returns stores' do
          get(path, params:)

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.pluck(:id)).to match_array([store1.id])
        end
      end

      context 'when request filters by close_hour' do
        let(:close_hour) { '17:00' }

        before do
          working_hours.update(close_hour:)
          params.update({ close_hour: })
        end

        it 'returns stores' do
          get(path, params:)

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.pluck(:id)).to match_array([store1.id])
        end
      end

      context 'when request filters by address' do
        before do
          store1.address.update(house_number: 'address')
          params.update({ address: 'address'})
        end

        it 'returns stores' do
          get(path, params:)

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.pluck(:id)).to match_array([store1.id])
        end
      end
    end
  end
end
