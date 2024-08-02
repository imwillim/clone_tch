# frozen_string_literal: true

require 'rails_helper'

describe GetProductsService do
  subject(:service) { described_class.new(category_id) }

  let(:all_category) { create(:category, name: 'all') }
  let(:tea_category) { create(:category, parent: all_category, name: 'tea') }
  let(:coffee_category) { create(:category, parent: all_category, name: 'coffee') }
  let(:milk_tea_category) { create(:category, parent: tea_category, name: 'milk_tea') }
  let(:hi_tea_category) { create(:category, parent: tea_category, name: 'hi_tea') }

  let!(:americano) { create(:product, category: coffee_category) }
  let!(:iced_coffee) { create(:product, category: coffee_category) }
  let!(:hi_tea) { create(:product, category: hi_tea_category) }
  let!(:milk_tea) { create(:product, category: milk_tea_category) }

  describe '#validate' do
    context 'when category_id does not exist in db' do
      let(:category_id) { SecureRandom.uuid }

      it 'returns error' do
        service.call

        expect(service.error?).to eq true
        expect(service.first_error.message).to eq 'category is not found.'
      end
    end

    describe '#call' do
      context 'when a category does not have a parent category' do
        let(:category_id) { all_category.id }
        let(:expected_result) do
          [
            { category_id: milk_tea_category.id, product_id: milk_tea.id },
            { category_id: coffee_category.id, product_id: iced_coffee.id },
            { category_id: coffee_category.id, product_id: americano.id },
            { category_id: hi_tea_category.id, product_id: hi_tea.id }
          ]
        end

        let(:actual_result) do
          service.result.map do |item|
            {
              category_id: item[:category_id],
              product_id: item[:product_id]
            }
          end
        end

        it 'returns categories having products' do
          service.call

          expect(service.success?).to eq true
          expect(service.result.size).to eq 4
          expect(actual_result).to match_array(expected_result)
        end
      end

      context 'when a category has a parent category' do
        let(:actual_result) do
          service.result.map do |item|
            {
              category_id: item[:category_id],
              product_id: item[:product_id]
            }
          end
        end

        context 'when a category has children categories' do
          let(:category_id) { tea_category.id }
          let(:expected_result) do
            [
              { category_id: milk_tea_category.id, product_id: milk_tea.id },
              { category_id: hi_tea_category.id, product_id: hi_tea.id }
            ]
          end

          it 'returns children categories having products' do
            service.call

            expect(service.success?).to eq true
            expect(service.result.size).to eq 2
            expect(actual_result).to match_array(expected_result)
          end
        end

        context 'when a category does not have children categories' do
          let(:category_id) { milk_tea_category.id }
          let(:actual_result) { service.result.first }

          it 'returns that category having products' do
            service.call

            expect(service.success?).to eq true
            expect(service.result.size).to eq 1
            expect(actual_result[:category_id]).to eq milk_tea_category.id
            expect(actual_result[:product_id]).to eq milk_tea.id
          end
        end
      end
    end
  end
end
