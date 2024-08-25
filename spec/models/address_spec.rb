# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:city) { create(:city) }
  let(:store) { create(:store, name: 'A') }
  let!(:address) do
    create(:address, house_number: '1A', street: 'Lê Văn Sĩ', ward: '3', district: 'Tân Bình',
                     city:, store:)
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:house_number) }
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:ward) }
    it { is_expected.to validate_presence_of(:district) }
    it {
      is_expected.to validate_uniqueness_of(:house_number)
        .scoped_to(%i[street ward district]).with_message('address has been taken.')
    }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:store) }
    it { is_expected.to belong_to(:city) }
  end
end
