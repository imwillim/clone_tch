# frozen_string_literal: true

class StoresController < ApplicationController
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

  schema(:show) do
    required(:id).value(:integer)
  end

  def show
    result = StoreWorkingHour.includes(:store, :working_hour).where(store_id: params[:id])

    render json: result, each_serializer: StoreWorkingHourSerializer
    # TODO: query -> serializer -> response -> request
  end

  private

  def process_service(service_name:, params: {})
    service = service_name.call(**params)

    raise CustomErrors::UnprocessableService, service.first_error if service.error?

    service.result
  end
end
