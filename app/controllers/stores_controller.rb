# frozen_string_literal: true

class StoresController < ApplicationController
  DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze
  CITY_CODES = %w[HCM HN].freeze
  AVAILABILITY = %w[WEEKDAY WEEKEND].freeze
  TIME_REGEX = /^([01]?[0-9]|2[0-3]):([0-5]?[0-9])$/

  schema(:directions) do
    required(:id).filled(:integer)
    required(:address).value(:string)
    optional(:transportation).value(:string)
  end

  def directions
    coordinates = process_service(service_name: GetUserCoordinatesService, params: { address: safe_params[:address] })

    directions = process_service(service_name: GetDirectionsService,
                                 params: {
                                   store_id: safe_params[:id],
                                   transportation: safe_params[:transportation],
                                   user_coordinates: coordinates
                                 })

    render json: { data: directions }, status: :ok
  end

  schema(:index) do
    optional(:days).array(:string).each(included_in?: DAYS)
    optional(:open_hour).value(format?: TIME_REGEX)
    optional(:close_hour).value(format?: TIME_REGEX)
    optional(:address).filled(:string)
    optional(:city_code).value(included_in?: CITY_CODES)
    optional(:availability).array(:string).each(included_in?: AVAILABILITY)
  end

  def index
    validate_time_interval if safe_params[:close_hour] && safe_params[:open_hour]

    service = GetStoresService.call(safe_params)

    if service.success?
      render json: service.result
    else
      render json: { message: service.first_error&.message }, status: :unprocessable_entity
    end
  end

  private

  def process_service(service_name:, params: {})
    service = service_name.call(**params)

    raise CustomErrors::UnprocessableService, service.first_error if service.error?

    service.result
  end

  def validate_time_interval
    if safe_params[:close_hour] < safe_params[:open_hour]
      raise ::CustomErrors::InvalidParams, 'close_hour cannot be less than open_hour'
    end
  end
end
