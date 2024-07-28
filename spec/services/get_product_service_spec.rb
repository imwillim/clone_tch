# frozen_string_literal: true

require 'rails_helper'

describe GetProductService do
  subject(:service) { described_class.new(product_id) }

  let(:product_id) { SecureRandom.uuid }

  let!(:category) { create(:category) }
  let!(:sizes) { create_list(:size, 2, product: second_product) }
  let!(:toppings) { create_list(:topping, 2, product: second_product) }
  let!(:tag) { create(:tag, product: second_product) }
  let!(:first_product) { create(:product, category:) }
  let!(:second_product) { create(:product, id: product_id, category:) }

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
      let(:another_product_id) { SecureRandom.uuid }
      let(:second_product) { create(:product, id: another_product_id, category:, name: 'Trà sữa') }

      it 'returns error' do
        service.call

        expect(service.error?).to eq true
        expect(service.first_error.message).to eq 'product is not found.'
      end
    end
  end

  describe '#call' do
    context 'when validation succeeds' do
      it 'returns first_product' do
        service.call

        expect(service.success?).to eq true
        expect(service.result.id).to eq second_product.id
        expect(service.result.id).not_to eq first_product.id
      end
    end
  end
end
