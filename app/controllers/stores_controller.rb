# frozen_string_literal: true

class StoresController < ApplicationController
  DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze
  CITY_CODES = %w[HCM HN].freeze
  AVAILABILITY = %w[MORNING AFTERNOON EVENING WEEKDAY WEEKEND].freeze

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
    optional(:open_hour).value(:time)
    optional(:close_hour).value(:time)
    optional(:address).filled(:string)
    optional(:city_code).value(included_in?: CITY_CODES)
    optional(:availability).array(:string).each(included_in?: AVAILABILITY)
  end

  def index
    if safe_params[:open_hour] && safe_params[:close_hour]
      if safe_params[:close_hour] < safe_params[:open_hour]
        raise ::CustomErrors::InvalidParams, 'close_hour cannot be less than open_hour'
      end
    end

    stores = Store.includes(:working_hours).where.associated(:working_hours)

    stores = stores.where('working_hours.day': safe_params[:days]) if safe_params[:days].present?
    stores = stores.where('working_hours.open_hour': safe_params[:open_hour].strftime('%H:%M')..) if safe_params[:open_hour].present?
    stores = stores.where('working_hours.close_hour': ..safe_params[:close_hour].strftime('%H:%M')) if safe_params[:close_hour].present?
    stores = stores.joins(:city).where('cities.code': safe_params[:city_code]) if safe_params[:city_code].present?

    if safe_params[:address].present?
      stores = stores.includes(:address)
                     .where('addresses.computed_address LIKE ?', "%#{Store.sanitize_sql_like(safe_params[:address])}%")
    end

    if safe_params[:availability].present?
      if (%w[WEEKEND WEEKDAY] & safe_params[:availability]) != %w[WEEKEND WEEKDAY]
        if safe_params[:availability].include?('WEEKEND')
          stores = stores.where('working_hours.day': %w[Saturday Sunday])
        end
        if safe_params[:availability].include?('WEEKDAY')
          stores = stores.where('working_hours.day': %w[Monday Tuesday Wednesday Thursday Friday])
        end
      end

      # if (%w[WEEKEND WEEKDAY] & safe_params[:availability]) == %w[WEEKEND WEEKDAY]
      #   stores = stores.and(Store.where('working_hours.day': %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]))
      # end
    end

    render json: stores
  end

  private

  def process_service(service_name:, params: {})
    service = service_name.call(**params)

    raise CustomErrors::UnprocessableService, service.first_error if service.error?

    service.result
  end
end
