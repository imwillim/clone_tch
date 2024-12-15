# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_one(:city).through(:address) }
    it { is_expected.to have_many(:facilities_stores).dependent(:destroy) }
    it { is_expected.to have_many(:facilities).through(:facilities_stores) }
  end
end
