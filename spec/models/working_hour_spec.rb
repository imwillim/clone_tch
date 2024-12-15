# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkingHour, type: :model do
  let(:store) { create(:store) }
  let!(:working_hour) { create(:working_hour, open_hour: '11:00', close_hour: '20:00', store:) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:open_hour) }
    it { is_expected.to validate_presence_of(:close_hour) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:store) }
  end
end
