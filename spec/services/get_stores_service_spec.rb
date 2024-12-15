# frozen_string_literal: true

require 'rails_helper'

describe GetStoresService do
  subject(:service) { described_class.new(safe_params) }

  let!(:working_hour1) { create(:working_hour, store: store1, day: 'Monday', open_hour: '13:00', close_hour: '17:00') }
  let!(:working_hour2) { create(:working_hour, store: store2, day: 'Sunday') }

  let(:city) { create(:city, code: 'HCM') }
  let!(:address) { create(:address, city:, store: store1) }
  let(:store1) { create(:store) }
  let(:store2) { create(:store) }

  let(:safe_params) do
    {
      days:,
      open_hour:,
      close_hour:,
      address:,
      city_code:,
      availability:
    }
  end

  describe 'when no filters' do
    it 'returns stores' do
      service.call

      expect(service.success?).to eq true
      expect(service.result.pluck(:id)).to match_array([store1.id, store2.id])
    end
  end

  let(:safe_params) { {} }

  describe 'when filter by days' do
    let(:days) { ['Monday'] }
    let(:safe_params) do
      {
        days:
      }
    end

    it 'returns a store' do
      service.call

      expect(service.success?).to eq true
      expect(service.result.pluck(:id)).to eq([store1.id])
    end
  end

  describe 'when filter by open_hour' do
    let(:open_hour) { '13:00' }
    let(:safe_params) do
      {
        open_hour:
      }
    end

    it 'returns a store' do
      service.call

      expect(service.success?).to eq true
      expect(service.result.pluck(:id)).to eq([store1.id])
    end
  end

  describe 'when filter by close_hour' do
    let(:close_hour) { '17:00' }
    let(:safe_params) do
      {
        close_hour:
      }
    end

    it 'returns a store' do
      service.call

      expect(service.success?).to eq true
      expect(service.result.pluck(:id)).to eq([store1.id])
    end
  end

  describe 'when filter by address' do
    let(:safe_params) do
      {
        address: address.street.to_s
      }
    end

    it 'returns a store' do
      service.call

      expect(service.success?).to eq true
      expect(service.result.pluck(:id)).to eq([store1.id])
    end
  end

  describe 'when filter by city_code' do
    let(:city_code) { city.code }
    let(:safe_params) do
      {
        city_code:
      }
    end

    it 'returns a store' do
      service.call

      expect(service.success?).to eq true
      expect(service.result.pluck(:id)).to eq([store1.id])
    end
  end

  describe 'when filter by city_code' do
    let(:city_code) { city.code }
    let(:safe_params) do
      {
        city_code:
      }
    end

    it 'returns a store' do
      service.call

      expect(service.success?).to eq true
      expect(service.result.pluck(:id)).to eq([store1.id])
    end
  end

  describe 'when filter by availability' do
    let(:availability) { ['WEEKDAY'] }
    let(:safe_params) do
      {
        availability:
      }
    end

    it 'returns a store' do
      service.call

      expect(service.success?).to eq true
      expect(service.result.pluck(:id)).to eq([store1.id])
    end
  end
end
