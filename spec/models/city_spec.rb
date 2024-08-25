# frozen_string_literal: true

require 'rails_helper'

RSpec.describe City, type: :model do
  before do
    create(:city)
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }

    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_uniqueness_of(:code) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:addresses).dependent(:nullify) }
    it { is_expected.to have_many(:stores).through(:addresses) }
  end
end
