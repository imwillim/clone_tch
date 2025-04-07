# frozen_string_literal: true

RSpec.describe Order, type: :model do
  let(:order) { build(:order) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:store) }
  end
end
