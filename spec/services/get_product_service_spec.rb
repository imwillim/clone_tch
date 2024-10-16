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
    context 'when a cached product is present' do
      let(:cached_tea) { tea.to_json }
      include_context 'redis mock'

      before do
        allow(redis).to receive(:get).with(tea.id).and_return(cached_tea)
        allow(service).to receive(:call).and_return(cached_tea)
      end

      it 'sets the result to the cached value' do
        expect(JSON.parse(service.call)).to eq(JSON.parse(cached_tea))
      end
    end

    context 'when no cached product is present' do
      include_context 'redis mock'
      let(:tea_json) { tea.to_json }

      before do
        allow(redis).to receive(:get).with(tea.id).and_return(nil)
        allow(service).to receive(:fetch_cached_value).and_return(nil)

        allow(service).to receive(:assign_cached_value).with(tea)
        allow(service).to receive(:call).and_return(tea_json)
      end

      it 'fetches the product from the database and assigns it to the cache' do
        expect(service).to receive(:assign_cached_value).with(tea)

        expect(JSON.parse(service.call)).to eq(JSON.parse(tea_json))
      end
    end
  end
end
