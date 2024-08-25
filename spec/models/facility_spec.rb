# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Facility, type: :model do
  let!(:facility) { create(:facility, name: 'Phục vụ tại chỗ') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:facilities_stores).dependent(:destroy) }
    it { is_expected.to have_many(:stores).through(:facilities_stores) }
  end
end
