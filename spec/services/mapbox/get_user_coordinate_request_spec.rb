# frozen_string_literal: true

require 'rails_helper'

describe Mapbox::GetUserCoordinateRequest do
  let(:address_search) { 'phuong 3, quan go vap' }

  describe '#call' do
    context 'when the request is successfully' do
      subject(:request) { described_class.new(address_search:) }

      it 'returns correct value' do
        VCR.use_cassette('mapbox/get_user_coordinate_successfully') do
          request.call

          expect(request.success?).to eq true
        end
      end
    end
  end
end
