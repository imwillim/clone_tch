# frozen_string_literal: true

class GetStoresService < BaseService
  def initialize(safe_params)
    super()
    @days = safe_params[:days]
    @open_hour = safe_params[:open_hour]
    @close_hour = safe_params[:close_hour]
    @city_code = safe_params[:city_code]
    @address = safe_params[:address]
    @availability = safe_params[:availability]
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def call
    stores = Store.includes(:working_hours).where.associated(:working_hours)
    stores = stores.where('working_hours.day': @days) if @days.present?
    stores = stores.where('working_hours.open_hour': @open_hour..) if @open_hour.present?
    stores = stores.where('working_hours.close_hour': ..@close_hour) if @close_hour.present?
    stores = stores.joins(:city).where('cities.code': @city_code) if @city_code.present?

    if @address.present?
      stores = stores.includes(:address)
                     .where('addresses.computed_address LIKE ?', "%#{Store.sanitize_sql_like(@address)}%")
    end

    stores = filter_availability(stores) if @availability.present?
    @result = stores
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def filter_availability(result)
    filter_week(result) if (%w[WEEKEND WEEKDAY] & @availability) != %w[WEEKEND WEEKDAY]
  end

  def filter_week(result)
    result = result.where('working_hours.day': %w[Saturday Sunday]) if @availability.include?('WEEKEND')

    return result unless @availability.include?('WEEKDAY')

    result.where('working_hours.day': %w[Monday Tuesday Wednesday Thursday Friday])
  end
end
