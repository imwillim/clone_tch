# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FacilityStore, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:facility) }
    it { is_expected.to belong_to(:store) }
  end
end
