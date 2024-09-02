# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreWorkingHour, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:day) }

    context 'when price is negative' do
      let(:store_working_hour) { build(:store_working_hour) }

      before do
        store_working_hour.update(day: 'Not Valid')
      end

      it 'raises an error' do
        expect(store_working_hour).not_to be_valid
        expect(store_working_hour.errors[:day][0]).to eq 'day is not valid'
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:store) }
    it { is_expected.to belong_to(:working_hour) }
  end
end
