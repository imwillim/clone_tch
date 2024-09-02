# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkingHour, type: :model do
  let!(:working_hour) { create(:working_hour, open_hour: '11:00', close_hour: '20:00') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:open_hour) }
    it { is_expected.to validate_presence_of(:close_hour) }
    it {
      is_expected.to validate_uniqueness_of(:open_hour)
        .scoped_to(:close_hour).case_insensitive.with_message('working_hour has been taken.')
    }
  end

  describe 'associations' do
    it { is_expected.to have_many(:stores_working_hours).dependent(:destroy) }
    it { is_expected.to have_many(:stores).through(:stores_working_hours) }
  end
end
