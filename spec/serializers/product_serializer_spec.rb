# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSerializer, type: :serializer do
  let(:tea_category) { build(:category, name: 'tea_category') }
  let(:milk_tea) { build(:product, name: 'milk_tea', category: tea_category) }

  let(:milk_tea_json) { ProductSerializer.new(milk_tea).serializable_hash }

  context 'when serializing product' do
    let(:expected_milk_tea_json) do
      {
        id: milk_tea.id,
        name: milk_tea.name,
        price: milk_tea.price,
        image_urls: milk_tea.image_urls,
        description: milk_tea.description,
        sizes: [],
        toppings: [],
        tags: []
      }
    end
    it 'returns the expected json of product' do
      expect(milk_tea_json).to eq expected_milk_tea_json
    end
  end
end
