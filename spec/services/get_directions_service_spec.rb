# frozen_string_literal: true

require 'rails_helper'

describe GetDirectionsService, type: :service do
  subject(:service) { described_class.new(store_id:, transportation:, user_coordinates:) }

  let(:city) { create(:city) }
  let!(:address) { create(:address, longitude: 106.66, latitude: 10.79, city:, store:) }
  let(:store) { create(:store) }
  let(:store_id) { store.id }
  let(:transportation) { 'driving' }
  let(:user_coordinates) { [106.6732885, 10.8096836] }
  let(:store_coordinates) { [106.66, 10.79] }

  describe '#validate' do
    before do
      allow(CacheManager).to receive(:fetch_value).and_return(nil)
    end

    context 'when the store_id is not found in database' do
      let(:store_id) { nil }

      it 'returns error' do
        service.call

        expect(service.success?).to eq false
        expect(service.first_error.message).to eq 'store is not found.'
      end
    end

    context 'when store does not have an address' do
      before do
        store.address.destroy
      end

      it 'returns error' do
        service.call

        expect(service.success?).to eq false
        expect(service.first_error.message).to eq 'address of store is not found.'
      end
    end

    context 'when transportation is not valid' do
      let(:transportation) { 'transportation' }

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

      context 'when store coordinate exists in cache' do
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

      context 'when store coordinate does not exist in cache' do
        let(:cached_value) { JSON.parse(redis.get(store_id)) }

        include_context 'redis mock'

        before do
          allow(CacheManager).to receive(:fetch_value).and_return(nil)
          allow(Mapbox::GetDirectionsRequest).to receive(:call).with(user_coordinates:,
                                                                     store_coordinates:,
                                                                     transportation:)
                                                               .and_return(request_success)
        end

        it 'returns the result' do
          service.call

          expect(service.success?).to be true
          expect(service.result).to eq(result)
          expect(cached_value).to eq(store_coordinates)
        end
      end
    end
  end
end
