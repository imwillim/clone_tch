# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FacilitySerializer, type: :serializer do
  let(:facility) { build(:facility, name: 'Facility') }
  let(:store) { create(:store) }

  context 'when serializing facility' do
    context 'when store_id is passed as an argument' do
      let(:facility_json) { FacilitySerializer.new(facility, store_id: store.id).serializable_hash }
      let(:expected_facility) do
        {
          id: facility.id,
          name: facility.name,
          icon: facility.icon,
          created_at: facility.created_at,
          updated_at: facility.updated_at,
          store_id: store.id
        }
      end

      it 'returns serialized facility with store_id' do
        expect(facility_json).to eq(expected_facility)
      end
    end

    context 'when store_id is not passed as an argument' do
      let(:facility_json) { FacilitySerializer.new(facility).serializable_hash }
      let(:expected_facility) do
        {
          id: facility.id,
          name: facility.name,
          icon: facility.icon,
          created_at: facility.created_at,
          updated_at: facility.updated_at
        }
      end

      it 'returns serialized facility' do
        expect(facility_json).to eq(expected_facility)
      end
    end
  end
end
