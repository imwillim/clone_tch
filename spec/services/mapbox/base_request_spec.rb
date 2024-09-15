# frozen_string_literal: true

require 'rails_helper'

describe Mapbox::BaseRequest do
  describe '#connection' do
    context 'establishes a Faraday connection' do
      request = Mapbox::BaseRequest.new
      connection = request.connection

      it 'connects successfully' do
        expect(connection).to be_a(Faraday::Connection)
        expect(connection.url_prefix.to_s).to eq('https://api.mapbox.com/')
      end
    end

    context 'does not establish a Faraday connection' do
      before do
        allow(Faraday).to receive(:new).and_raise(Faraday::ConnectionFailed)
      end

      it 'raises an error when Faraday connection fails' do
        request = Mapbox::BaseRequest.new

        expect { request.connection }.to raise_error(Faraday::ConnectionFailed)
      end
    end
  end
end
