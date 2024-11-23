# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreSerializer, type: :serializer do
  let(:store) { build(:store, id: SecureRandom.uuid) }
  let(:store_json) { StoreSerializer.new(store).serializable_hash }

  context 'when serializing store' do
    let(:expected_store_json) do
      {
        name: store.name,
        image_urls: store.image_urls
      }
    end
    it 'returns the expected json of store' do
      expect(store_json).to eq expected_store_json
    end
  end
end
