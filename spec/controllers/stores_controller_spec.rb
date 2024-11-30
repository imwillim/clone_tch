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
    let(:params) do
      {
        days:
      }
    end

    let(:days) { %w[Monday] }
    let(:store) { create(:store) }
    let(:working_hour) { create(:working_hour, store_id: store.id) }

    describe '#validate' do
      context 'when days parameter not valid' do
        let(:days) { %w[days] }

        it 'returns 400 response' do
          get(path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors']).to eq('0 must be one of: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday')
        end
      end

      context 'when open hour is not in between 8:00 and 22:00' do
        let(:open_hour) { '23:00' }
        let(:params) do
          {
            open_hour:
          }
        end

        it 'returns 400 response' do
          get(path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors']).to eq('open_hour is in invalid format')
        end
      end

      context 'when close hour is not in between 8:00 and 22:00' do
        let(:close_hour) { '23:00' }
        let(:params) do
          {
            close_hour:
          }
        end

        it 'returns 400 response' do
          get(path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors']).to eq('close_hour is in invalid format')
        end
      end

      describe 'when request succeeds' do
        context 'when request does not have parameters' do
          let(:expected_result) do
            [{
              'id' => store.id,
              'name' => store.name,
              'working_hours' => [{
                 'id' => working_hour.id,
                 'day' => 'Monday',
                 'open_hour' => '9:30',
                 'close_hour' => '22:00'
               }]
            }]
          end

          it 'returns all stores' do
            get(path, params:)

            expect(response).to have_http_status(:ok)
            expect(response.parsed_body.to_json).to eq(expected_result.to_json)
          end
        end

        context 'when request filters a day not in weekdays' do
          let(:days) { %w[Tuesday] }
          let(:expected_result) { [] }

          it 'returns empty' do
            get(path, params:)

            expect(response).to have_http_status(:ok)
            expect(response.parsed_body).to eq(expected_result)
          end
        end

        context 'when request filters a day in weekdays' do
          let(:expected_result) do
            [{
              'id' => store.id,
              'name' => store.name,
              'working_hours' => [{
                 'id' => working_hour.id,
                 'day' => 'Monday',
                 'open_hour' => '9:30',
                 'close_hour' => '22:00'
               }]
            }]
          end

          it 'returns result of stores' do
            get(path, params:)

            expect(response).to have_http_status(:ok)
            expect(response.parsed_body).to eq(expected_result)
          end
        end
      end
      # TODO: Add Unit test for open_hour & close_hour filters
    end
  end

  describe 'GET /api/v1/tch/stores', type: :request do
    let(:path) { '/api/v1/tch/stores' }
    let(:params) do
      {
        days:
      }
    end

    let(:days) { %w[Monday] }
    let(:store) { create(:store) }
    let(:working_hour) { create(:working_hour) }

    describe '#validate' do
      context 'when days parameter not valid' do
        let(:days) { %w[invalid_days] }

        it 'returns 400 response' do
          get(path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors']).to eq('0 must be one of: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday')
        end
      end

      context 'when open hour is not in between 8:00 and 22:00' do
        let(:open_hour) { '23:00' }
        let(:params) do
          {
            open_hour:
          }
        end

        it 'returns 400 response' do
          get(path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors']).to eq('open_hour is in invalid format')
        end
      end

      context 'when close hour is not in between 8:00 and 22:00' do
        let(:close_hour) { '23:00' }
        let(:params) do
          {
            close_hour:
          }
        end

        it 'returns 400 response' do
          get(path, params:)

          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body['errors']).to eq('close_hour is in invalid format')
        end
      end

      describe 'when request succeeds' do
        context 'when request does not have parameters' do
          let(:another_store) { create(:store) }
          let(:another_working_hour) { create(:working_hour, store_id: another_store) }
          let(:expected_result) do
            [{
              'id' => another_store.id,
              'name' => another_store.name,
              'working_hours' => [{
                 'id' => another_working_hour.id,
                 'day' => 'Monday',
                 'open_hour' => '9:30',
                 'close_hour' => '22:00'
               }]
            },
             {
               'id' => store.id,
               'name' => store.name,
               'working_hours' => [{
                 'id' => working_hour.id,
                 'day' => 'Monday',
                 'open_hour' => '9:30',
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

        context 'when request filters a day not in weekdays' do
          let(:days) { %w[Tuesday] }
          let(:expected_result) { [] }

          it 'returns empty' do
            get(path, params:)

            expect(response).to have_http_status(:ok)
            expect(response.parsed_body).to eq(expected_result)
          end
        end

        context 'when request filters a day in weekdays' do
          let(:expected_result) do
            [{
              'id' => store.id,
              'name' => store.name,
              'working_hours' => [{
                 'id' => working_hour.id,
                 'day' => 'Monday',
                 'open_hour' => '9:30',
                 'close_hour' => '22:00'
               }]
            }]
          end

          it 'returns result of stores' do
            get(path, params:)

            expect(response).to have_http_status(:ok)
            expect(response.parsed_body).to eq(expected_result)
          end
        end
      end
      # TODO: Add Unit test for open_hour & close_hour filters
    end
  end
end
