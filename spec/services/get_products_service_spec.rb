# frozen_string_literal: true

require 'rails_helper'

describe GetProductsService do
  subject(:service) { described_class.new(category_id) }

  let(:all_category) { create(:category, name: 'all') }
  let(:tea_category) { create(:category, parent: all_category, name: 'Tea category') }
  let(:coffee_category) { create(:category, parent: all_category, name: 'Coffee category') }
  let(:milk_tea_category) { create(:category, parent: tea_category, name: 'Milk Tea category') }
  let(:hi_tea_category) { create(:category, parent: tea_category, name: 'Hi Tea category') }

  let!(:americano) { create(:product, category: coffee_category, name: 'Americano') }
  let!(:iced_coffee) { create(:product, category: coffee_category, name: 'Iced Coffee') }
  let!(:hi_tea) { create(:product, category: hi_tea_category, name: 'Hi Tea') }
  let!(:milk_tea) { create(:product, category: milk_tea_category, name: 'Milk Tea') }

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
            {
              name: 'Coffee category',
              products: match_array([
                                      {
                                        id: iced_coffee.id,
                                        name: iced_coffee.name,
                                        price: iced_coffee.price,
                                        thumbnail: iced_coffee.thumbnail,
                                        tag: {
                                          color: nil,
                                          name: nil
                                        }
                                      },
                                      {
                                        id: americano.id,
                                        name: americano.name,
                                        price: americano.price,
                                        thumbnail: americano.thumbnail,
                                        tag: {
                                          color: nil,
                                          name: nil
                                        }
                                      }
                                    ])

            },
            {
              name: 'Milk Tea category',
              products: match_array([{
                                      id: milk_tea.id,
                                      name: milk_tea.name,
                                      price: milk_tea.price,
                                      thumbnail: milk_tea.thumbnail,
                                      tag: {
                                        color: nil,
                                        name: nil
                                      }
                                    }])
            },
            {
              name: 'Hi Tea category',
              products: match_array([{
                                      id: hi_tea.id,
                                      name: hi_tea.name,
                                      price: hi_tea.price,
                                      thumbnail: hi_tea.thumbnail,
                                      tag: {
                                        color: nil,
                                        name: nil
                                      }
                                    }])
            }
          ]
        end

        it 'returns categories having products' do
          service.call

          expect(service.success?).to eq true
          expect(service.result.size).to eq 3

          expect(service.result).to match_array(expected_result)
        end
      end

      context 'when a category has a parent category' do
        context 'when a category has children categories' do
          let(:category_id) { tea_category.id }
          let(:expected_result) do
            [
              {
                name: 'Hi Tea category',
                products: match_array([{
                                        id: hi_tea.id,
                                        name: hi_tea.name,
                                        price: hi_tea.price,
                                        thumbnail: hi_tea.thumbnail,
                                        tag: {
                                          color: nil,
                                          name: nil
                                        }
                                      }])
              },
              {
                name: 'Milk Tea category',
                products: match_array([{
                                        id: milk_tea.id,
                                        name: milk_tea.name,
                                        price: milk_tea.price,
                                        thumbnail: milk_tea.thumbnail,
                                        tag: {
                                          color: nil,
                                          name: nil
                                        }
                                      }])
              }
            ]
          end
          it 'returns children categories having products' do
            service.call

            expect(service.success?).to eq true
            expect(service.result.size).to eq 2
            expect(service.result).to match_array(expected_result)
          end
        end

        context 'when a category does not have children categories' do
          let(:category_id) { milk_tea_category.id }
          let(:expected_result) do
            [
              {
                name: 'Milk Tea category',
                products: [
                  {
                    id: milk_tea.id,
                    name: 'Milk Tea',
                    price: 9.99,
                    thumbnail: 'MyString',
                    tag: {
                      name: nil,
                      color: nil
                    }
                  }
                ]
              }
            ]
          end

          it 'returns that category having products' do
            service.call

            expect(service.success?).to eq true
            expect(service.result.size).to eq 1
            expect(service.result.first[:products].size).to eq 1
            expect(service.result.first[:products].first[:id]).to eq expected_result.first[:products].first[:id]
          end
        end
      end
    end
  end
end
