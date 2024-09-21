# frozen_string_literal: true

module Mapbox
  class GetUserCoordinateRequest < BaseRequest
    ADDRESS_PATH = 'search/geocode/v6/forward'

    def initialize(address_search:)
      super()
      @address_search = address_search
    end

    def call
      @response = make_request
      handle_response(@response)
    rescue Faraday::Error => e
      add_error(e.message)
    end

    private

    def make_request
      connection.get(ADDRESS_PATH, params)
    end

    def handle_response(response)
      if response.status == SUCCESS_STATUS
        @response = response.body['features'].first['geometry']['coordinates']

        @response.presence || add_error(I18n.t('errors.models.not_found', record: :coordinate))
      else
        add_error(response.body['message'])
      end
    end

    def params
      {
        q: @address_search,
        access_token: @token
      }
    end
  end
end