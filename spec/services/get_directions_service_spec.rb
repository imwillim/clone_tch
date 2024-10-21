# frozen_string_literal: true

require 'rails_helper'

describe GetDirectionsService, type: :service do
  subject(:service) { described_class.new(store_id:, transportation:, user_coordinates:) }

  let(:city) { create(:city) }
  let!(:address) { create(:address, longitude: 106.66796536861601, latitude: 10.794422140319528, city:, store:) }
  let(:store) { create(:store) }
  let(:store_id) { store.id }
  let(:transportation) { 'driving' }
  let(:user_coordinates) { [106.6732885, 10.8096836] }
  let(:store_coordinates) { [106.66796536861601, 10.794422140319528] }

  describe '#validate' do
    context 'when the store_id is not found in database' do
      let(:store_id) { nil }

      before do
        allow(CacheManager).to receive(:fetch_value).and_return(nil)
      end

      it 'returns error' do
        service.call

        expect(service.success?).to eq false
        expect(service.first_error.message).to eq 'store is not found.'
      end
    end

    context 'when store does not have an address' do
      before do
        store.address.destroy
        allow(CacheManager).to receive(:fetch_value).and_return(nil)
      end

      it 'returns error' do
        service.call

        expect(service.success?).to eq false
        expect(service.first_error.message).to eq 'address of store is not found.'
      end
    end

    context 'when transportation is not valid' do
      let(:transportation) { 'transportation' }
      before do
        allow(CacheManager).to receive(:fetch_value).and_return(nil)
      end
      it 'returns error' do
        service.call

        expect(service.success?).to eq false
        expect(service.first_error.message).to eq 'transportation is not supported.'
      end
    end
  end

  describe '#call' do
    context 'when direction request succeeds' do
      let(:request_success) { instance_double(Mapbox::GetDirectionsRequest, error?: false, response: result) }
      let(:result) do
        [{ 'duration' => 602.736,
           'distance' => 3112.877,
           'steps' =>
             ['Drive southeast on Hồng Hà.',
              'Turn right onto Đường Hoàng Minh Giám.'] }]
      end

      context 'when store coordinate is fetched in cache' do
        before do
          allow(CacheManager).to receive(:fetch_value).and_return(store_coordinates.to_json)

          allow(Mapbox::GetDirectionsRequest).to receive(:call).with(user_coordinates:,
                                                                     store_coordinates:,
                                                                     transportation:)
                                                               .and_return(request_success)
        end

        it 'returns the result' do
          service.call

          expect(service.success?).to be true
          expect(service.result).to eq(result)
        end
      end

      context 'when store coordinate is not fetched in cache' do
        include_context 'redis mock'

        before do
          allow(CacheManager).to receive(:fetch_value).and_return(nil)
          allow(CacheManager).to receive(:assign_value).with(store_id, store_coordinates)

          allow(Mapbox::GetDirectionsRequest).to receive(:call).with(user_coordinates:,
                                                                     store_coordinates:,
                                                                     transportation:)
                                                               .and_return(request_success)
        end

        it 'returns the result' do
          service.call

          expect(service.success?).to be true
          expect(service.result).to eq(result)
        end
      end
    end

    context 'when direction request fails' do
      let(:request_failure) do
        instance_double(Mapbox::GetDirectionsRequest, error?: true,
                                                      first_error: StandardError.new('Request error'))
      end

      before do
        allow(CacheManager).to receive(:fetch_value).and_return(store_coordinates.to_json)
        allow(Mapbox::GetDirectionsRequest).to receive(:call).with(user_coordinates:,
                                                                   store_coordinates:,
                                                                   transportation:)
                                                             .and_return(request_failure)
      end

      it 'adds errors' do
        service.call

        expect(service.success?).to be false
        expect(service.first_error.message).to eq 'Request error'
      end
    end
  end
end
