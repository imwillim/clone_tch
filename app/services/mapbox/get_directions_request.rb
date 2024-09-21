# frozen_string_literal: true

module Mapbox
  class GetDirectionsRequest < BaseRequest
    DIRECTION_PATH = 'directions/v5/mapbox'

    def initialize(user_coordinates:, store_coordinates:, transportation:)
      super()
      @user_coordinates = user_coordinates.join(',')
      @store_coordinates = store_coordinates.join(',')
      @transportation = transportation
    end

    def call
      @response = make_request
      handle_response(@response)
    rescue Faraday::Error => e
      add_error(e)
    end

    private

    def handle_response(response)
      if response.status == SUCCESS_STATUS && response.body['code'] == 'Ok'
        @response = transform_directions(response.body)
      else
        add_error(response.body['message'])
      end
    end

    def transform_directions(response_body)
      response_body['routes'].map do |route|
        {
          'duration' => route['duration'],
          'distance' => route['distance'],
          'steps' => extract_steps(route)
        }
      end
    end

    def extract_steps(route)
      route['legs'].first['steps'].map do |step|
        step['maneuver']['instruction']
      end
    end

    def make_request
      coordinates = "#{@user_coordinates};#{@store_coordinates}"

      coordinates_path = "#{DIRECTION_PATH}/#{@transportation}/#{coordinates}"
      connection.get(coordinates_path, params)
    end

    def params
      {
        overview: 'full',
        steps: 'true',
        access_token: @token
      }
    end
  end
end
