# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreSerializer, type: :serializer do
  let(:city) { create(:city) }
  let!(:address) { create(:address, city:, store:) }
  let(:store) { create(:store) }

  describe '#serialize' do
    let(:expected_result) do
      {
        id: store.id,
        name: store.name,
        address: "#{address.house_number} #{address.street}, #{address.ward}, #{address.district}, #{city.name}",
        working_hours: []
      }
    end

    it 'returns a serialized store' do
      result = StoreSerializer.new(store).serializable_hash

      expect(result).to eq expected_result
    end
  end
end
