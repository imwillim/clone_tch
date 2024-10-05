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
end
