# frozen_string_literal: true

module Mapbox
  class BaseRequest < BaseService
    attr_reader :response

    SUCCESS_STATUS = 200
    # TEST COMMIT
    BASE_ENDPOINT = 'https://api.mapbox.com'
    ACCESS_TOKEN = ENV.fetch('MAP_BOT_ACCESS_TOKEN')

    def connection
      return @connection if defined?(@connection)

      @connection = Faraday.new(url: BASE_ENDPOINT) do |conn|
        conn.response :json
      end
    end
  end
end
