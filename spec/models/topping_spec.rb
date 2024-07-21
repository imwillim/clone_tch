require 'rails_helper'

RSpec.describe Topping, type: :model do
  let(:topping) { build(:topping) }

  describe 'validations' do
    before do
      topping.update(price: -1)
    end
    it 'raise an error' do
      expect(topping).not_to be_valid
      expect(topping.errors[:price].first).to eq 'Price of topping must be greater than 0'
    end
  end
end
