# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkingHourSerializer, type: :serializer do
  let(:working_hour) { build(:working_hour, id: SecureRandom.uuid) }
  let(:working_hour_json) { WorkingHourSerializer.new(working_hour).serializable_hash }

  context 'when serializing working hour' do
    let(:expected_working_hour_json) do
      {
        open_hour: working_hour.open_hour,
        close_hour: working_hour.close_hour,
      }
    end
    it 'returns the expected json of working hour' do
      expect(working_hour_json).to eq expected_working_hour_json
    end
  end
end
