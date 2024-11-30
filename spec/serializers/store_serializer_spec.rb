# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreSerializer, type: :serializer do
  let(:store) { build(:store) }
  let(:working_hour) { build(:working_hour) }

  describe '#serialize' do
    let(:expected_result) do
      {
        id: nil,
        name: store.name,
        working_hours: []
      }
    end

    it 'returns a serialized store' do
      result = StoreSerializer.new(store).serializable_hash

      expect(result).to eq expected_result
    end
  end
end
