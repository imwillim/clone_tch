# frozen_string_literal: true

require 'rails_helper'

describe BaseService, type: :service do
  subject(:service) { described_class.new }

  describe '#add_error' do
    before do
      service.add_error(err)
    end

    context 'when errors is an array' do
      let(:err) { ['sth wrong', 'sth incorrect'] }

      it 'returns correct error' do
        expect(service.errors.map(&:to_s)).to eq ['sth wrong', 'sth incorrect']
      end
    end

    context 'when errors is a standard error' do
      let(:err) { StandardError.new('sth_wrong') }

      it 'returns correct error' do
        expect(service.first_error.to_s).to eq 'sth_wrong'
      end
    end
  end

  describe '#success?' do
    it 'returns success' do
      expect(service.success?).to be true
      expect(service.error?).to be false
    end
  end

  describe '#error?' do
    before { service.add_error('sth_wrong') }

    it 'returns error' do
      expect(service.error?).to be true
      expect(service.success?).to be false
    end
  end

  describe '#first_error' do
    before { service.add_error(%w[error1 error2]) }

    it 'returns first error' do
      expect(service.first_error.to_s).to eq 'error1'
    end
  end
end
