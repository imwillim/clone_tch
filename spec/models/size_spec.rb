# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Size, type: :model do
  let(:size) { build(:size) }

  describe 'validations' do
    context 'when price is negative' do
      before do
        size.update(price: -1)
      end

      it 'raises an error' do
        expect(size).not_to be_valid
        expect(size.errors[:price][0]).to eq 'Price of size must be greater than 0'
      end
    end
  end
end
