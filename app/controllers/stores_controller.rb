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
    optional(:page).value(:integer, gteq?: 1)
    optional(:items_per_page).value(:integer, gteq?: 1)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def index
    validate_time_interval if safe_params[:close_hour] && safe_params[:open_hour]

    service = GetStoresService.call(safe_params)

    if service.success?
      result = service.result
      render json: { items: result,
                     total_pages: result.total_pages,
                     total_items: result.total_count,
                     page_index: safe_params[:page],
                     items_per_page: safe_params[:items_per_page] || ::GetStoresService::DEFAULT_ITEM_PER_PAGE }
    else
      render json: { message: service.first_error&.message }, status: :unprocessable_entity
    end
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def process_service(service_name:, params: {})
    service = service_name.call(**params)

    raise CustomErrors::UnprocessableService, service.first_error if service.error?

    service.result
  end

  def validate_time_interval
    return unless safe_params[:close_hour] < safe_params[:open_hour]

    raise ::CustomErrors::InvalidParams, 'close_hour cannot be less than open_hour'
  end
end
