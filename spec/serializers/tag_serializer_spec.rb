# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagSerializer, type: :serializer do
  let(:new_tag) { build(:tag, id: SecureRandom.uuid) }
  let(:new_tag_json) { TagSerializer.new(new_tag).serializable_hash }

  context 'when serializing tag' do
    let(:expected_new_tag_json) do
      {
        id: new_tag.id,
        name: new_tag.name,
        color: new_tag.color
      }
    end
    it 'returns the expected json of tag' do
      expect(new_tag_json).to eq expected_new_tag_json
    end
  end
end
