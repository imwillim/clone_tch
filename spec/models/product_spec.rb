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

  describe 'associations' do
    it { is_expected.to have_many(:sizes) }
    it { is_expected.to have_many(:toppings) }
    it { is_expected.to have_and_belong_to_many(:tags) }
  end

  describe '#update_cache' do
    context 'when product is updated' do
      let(:category) { create(:category) }
      let(:product) { create(:product, category:) }

      let(:body) { { 'name' => 'Tea' } }
      let(:cached_product) { redis.get(product.id) }

      include_context 'redis mock'

      before do
        redis.set(product.id, product.to_json)
      end

      it 'invalidates product' do
        product.update!(body)

        expect(cached_product).to eq(product.to_json)
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
