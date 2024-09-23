# frozen_string_literal: true

require 'rails_helper'

describe GetUserCoordinatesService, type: :service do
  subject(:service) { described_class.new(address:) }
  let(:address) { 'ward 3, district 3' }
  let(:address_search) { address }

  describe '#validate' do
    context 'when address is empty' do
      let(:address) { '' }

      it 'returns error' do
        service.call

        expect(service.success?).to eq false
        expect(service.first_error.message).to eq 'address is empty'
      end
    end
  end

  describe '#call' do
    context 'when user coordination request succeeds' do
      let(:request_success) { instance_double(Mapbox::GetUserCoordinateRequest, error?: false, response: result) }
      let(:result) { [101, 90] }

      before do
        allow(Mapbox::GetUserCoordinateRequest).to receive(:call).with(address_search:).and_return(request_success)
      end

      it 'returns result' do
        service.call

        expect(service.success?).to be true
      end
    end

    context 'when user coordination request fails' do
      let(:request_failure) do
        instance_double(Mapbox::GetUserCoordinateRequest, error?: true, first_error: StandardError.new('Request error'))
      end

      before do
        allow(Mapbox::GetUserCoordinateRequest).to receive(:call).with(address_search:).and_return(request_failure)
      end

      it 'adds errors' do
        service.call

        expect(service.success?).to be false
        expect(service.first_error.message).to eq 'Request error'
      end
    end
  end
end
