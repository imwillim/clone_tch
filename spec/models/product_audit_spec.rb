# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductAudit, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:product) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:old_price) }
    it { is_expected.to validate_presence_of(:new_price) }
    it { is_expected.to validate_presence_of(:version) }

    it { is_expected.to validate_numericality_of(:old_price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:new_price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:version).only_integer }
    it { is_expected.to validate_numericality_of(:version).is_greater_than_or_equal_to(0) }
  end
end
