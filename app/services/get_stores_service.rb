# frozen_string_literal: true

class GetStoresService < BaseService
  DEFAULT_ITEM_PER_PAGE = 10

  def initialize(safe_params)
    super()
    @days = safe_params[:days]
    @open_hour = safe_params[:open_hour]
    @close_hour = safe_params[:close_hour]
    @city_code = safe_params[:city_code]
    @address = safe_params[:address]
    @availability = safe_params[:availability]
    @page = safe_params[:page]
    @items_per_page = safe_params[:items_per_page] || DEFAULT_ITEM_PER_PAGE
  end

  def call
    @scope = Store.includes(:working_hours).where.associated(:working_hours)

    filter_time
    filter_location
    filter_week if @availability.present? && (%w[WEEKEND WEEKDAY] & @availability) != %w[WEEKEND WEEKDAY]

    @result = scope.page(@page).per(@items_per_page)
  end

  private

  attr_accessor :scope

  def filter_time
    @scope = @scope.where('working_hours.day': @days) if @days.present?
    @scope = @scope.where('working_hours.open_hour': @open_hour..) if @open_hour.present?
    @scope = @scope.where('working_hours.close_hour': ..@close_hour) if @close_hour.present?
  end

  def filter_location
    @scope = @scope.joins(:city).where('cities.code': @city_code) if @city_code.present?

    return if @address.blank?

    @scope = @scope.includes(:address)
                   .where('addresses.computed_address LIKE ?', "%#{Store.sanitize_sql_like(@address)}%")
  end

  def filter_week
    @scope = @scope.where('working_hours.day': %w[Saturday Sunday]) if @availability.include?('WEEKEND')

    return @scope unless @availability.include?('WEEKDAY')

    @scope = @scope.where('working_hours.day': %w[Monday Tuesday Wednesday Thursday Friday])
  end
end
