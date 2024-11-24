# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreWorkingHourSerializer, type: :serializer do
  let(:working_hour) { build(:working_hour) }
  let(:store_working_hour) { build(:store_working_hour, day: 'Monday', working_hour:) }
  let(:store_working_hour_json) { StoreWorkingHourSerializer.new(store_working_hour).serializable_hash }

  context 'when serializing store working hour' do
    let(:expected_store_working_hour_json) do
      {
        day: 'Monday',
        open_hour: '9:30',
        close_hour: '22:00'
      }
    end
    it 'returns the expected json of store working hour' do
      expect(store_working_hour_json).to eq expected_store_working_hour_json
    end
  end
end
