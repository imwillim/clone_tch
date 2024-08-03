# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ToppingSerializer, type: :serializer do
  let(:jelly) { build(:topping, id: SecureRandom.uuid) }
  let(:jelly_json) { ToppingSerializer.new(jelly).serializable_hash }

  context 'when serializing topping' do
    let(:expected_jelly_json) do
      {
        id: jelly.id,
        name: jelly.name,
        price: jelly.price
      }
    end
    it 'returns the expected json of topping' do
      expect(jelly_json).to eq expected_jelly_json
    end
  end
end
