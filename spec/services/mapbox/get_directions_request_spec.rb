# frozen_string_literal: true

require 'rails_helper'

describe Mapbox::GetDirectionsRequest do
  let(:user_coordinates) { [106.6732885, 10.8096836] }
  let(:store_coordinates) { [106.6653261, 10.7943273] }
  let(:transportation) { 'driving' }

  subject(:request) do
    described_class.new(user_coordinates:,
                        store_coordinates:,
                        transportation:)
  end

  describe '#call' do
    context 'when the request is successfully' do
      subject(:request) { described_class.new(user_coordinates:, store_coordinates:, transportation:) }

      it 'returns correct value' do
        VCR.use_cassette('mapbox/get_user_directions_successfully') do
          request.call

          expect(request.success?).to eq true
        end
      end
    end

    context 'when the request fails' do
      context 'when the transportation not valid' do
        let(:transportation) { 'truck' }
        it 'adds an error message' do
          VCR.use_cassette('mapbox/get_users_direction_invalid_transportation') do
            request.call

            expect(request.error?).to eq true
            expect(request.first_error.message).to eq 'truck profile not allowed'
          end
        end
      end

      context 'when the coordinates having latitude not valid' do
        let(:user_coordinates) { [91, 91] }
        let(:store_coordinates) { [92, 92] }

        it 'adds an error message' do
          VCR.use_cassette('mapbox/get_users_direction_invalid_latitude_coordinates') do
            request.call

            expect(request.error?).to eq true
            expect(request.first_error.message).to eq 'Latitude must be between -90 and 90'
          end
        end
      end
    end
  end
end
