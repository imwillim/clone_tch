# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product do
  let(:product) { build(:product) }

  describe 'validations' do
    context 'when price is negative' do
      before do
        product.update(price: -1)
      end

      it 'raises an error' do
        expect(product).not_to be_valid
        expect(product.errors[:price][0]).to eq 'Price of product must be greater than 0'
      end
    end
  end

  describe '#invalidate_cache' do
    context 'when product exists in cache' do
      include_context 'redis mock'
      let(:category) { create(:category) }
      let(:product) { create(:product, category:) }

      before do
        redis.set(product.id, product.to_json)
      end

      it 'invalidates product' do
        product.destroy

        expect(redis.get(product.id)).to eq(nil)
      end
    end
  end
end
