# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreWorkingHourSerializer, type: :serializer do
  let(:store) { build(:store) }
  let(:working_hour) { build(:working_hour) }
  let(:store_working_hour) { build(:store_working_hour, working_hour:, store:) }

  describe '#serialize' do
    let(:expected_result) do
      {
        day: 'Monday',
        open_hour: '9:30',
        close_hour: '22:00'
      }
    end

    it 'returns a serialized store working hour' do
      result = StoreWorkingHourSerializer.new(store_working_hour).serializable_hash

      expect(result).to eq(expected_result)
    end
  end
end
