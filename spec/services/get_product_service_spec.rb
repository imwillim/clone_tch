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
    context 'when validation succeeds' do
      let(:product_id) { tea.id }

      it 'returns tea' do
        service.call

        expect(service.success?).to eq true
        expect(service.result.id).to eq tea.id
        expect(service.result.id).not_to eq milk_tea.id
      end
    end
  end
end
