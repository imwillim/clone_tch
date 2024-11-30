# frozen_string_literal: true

class StoresController < ApplicationController
  TIME_RANGE = /\A(08:00|08:[0-5]\d|0[89]:\d{2}|1[0-9]:\d{2}|20:[0-5]\d|21:[0-5]\d|22:00)\z/

  WEEKDAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

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
    optional(:days).array(:string).each(included_in?: WEEKDAYS)
    optional(:open_hour).value(:string, format?: TIME_RANGE)
    optional(:close_hour).value(:string, format?: TIME_RANGE)
  end

  def index
    stores = Store.includes(:working_hours).where.not('working_hours.day': nil)

    stores = stores.where('working_hours.day': safe_params[:days]) if safe_params[:days].present?
    stores = stores.where('working_hours.open_hour': safe_params[:open_hour]..) if safe_params[:open_hour].present?
    stores = stores.where('working_hours.close_hour': ..safe_params[:close_hour]) if safe_params[:close_hour].present?

    render json: stores
  end

  private

  def process_service(service_name:, params: {})
    service = service_name.call(**params)

    raise CustomErrors::UnprocessableService, service.first_error if service.error?

    service.result
  end
end
