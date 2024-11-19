# frozen_string_literal: true

require 'rails_helper'

describe GetProductService do
  subject(:service) { described_class.new(product_id) }

  let(:product_id) { SecureRandom.uuid }

  let!(:tea_category) { create(:category, name: 'tea_category') }
  let!(:sizes) { create_list(:size, 2, product: milk_tea) }
  let!(:toppings) { create_list(:topping, 2, product: milk_tea) }
  let!(:tag) { create(:tag, product: milk_tea) }
  let!(:milk_tea) { create(:product, category: tea_category, name: 'milk tea') }
  let!(:tea) { create(:product, category: tea_category, name: 'tea') }

  describe '#validate' do
    before do
      allow(CacheManager).to receive(:fetch_value).and_return(nil)
    end

    context 'when product_id is nil' do
      let(:product_id) { nil }

      it 'returns error' do
        service.call

        expect(service.error?).to eq true
        expect(service.first_error.message).to eq 'product is not found.'
      end
    end

    context 'when product_id does not exist in database' do
      let(:product_id) { SecureRandom.uuid }

      it 'returns error' do
        service.call

        expect(service.error?).to eq true
        expect(service.first_error.message).to eq 'product is not found.'
      end
    end
  end

  describe '#call' do
    include_context 'redis mock'
    let(:product_id) { tea.id }

    context 'when a product exists in cache' do
      before do
        allow(CacheManager).to receive(:fetch_value).and_return(tea.to_json)
      end
      it 'returns cached product' do
        service.call

        expect(service.success?).to eq true
        expect(service.result['id']).to eq tea.id
      end
    end

    context 'when a product does not exist in cache' do
      before do
        allow(CacheManager).to receive(:fetch_value).and_return(nil)
      end

      let(:expected_result) {
        {
          id: tea.id,
          name: tea.name,
          description: tea.description,
          price: tea.price,
          image_urls: tea.image_urls,
          sizes: [],
          toppings: [],
          tag: nil
        }
      }

      it 'returns product from database' do
        service.call

        expect(service.success?).to eq true
        expect(service.result['id']).to eq(tea.id)
        expect(redis.get(tea.id)).to eq expected_result.to_json
      end
    end
  end
end
