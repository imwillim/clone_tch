# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SizeSerializer, type: :serializer do
  let(:small_size) { build(:size, id: SecureRandom.uuid) }
  let(:small_size_json) { SizeSerializer.new(small_size).serializable_hash }

  context 'when serializing size' do
    let(:expected_size_json) do
      {
        id: small_size.id,
        name: small_size.name,
        icon: small_size.icon,
        price: small_size.price
      }
    end
    it 'returns the expected json of size' do
      expect(small_size_json).to eq expected_size_json
    end
  end
end
