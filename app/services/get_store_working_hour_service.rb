# frozen_string_literal: true

class GetStoreWorkingHourService < BaseService
  def initialize(store_id)
    super()
    @store_id = store_id
  end

  def call
    @result = StoreWorkingHour.includes(:store, :working_hour)
                              .where(store_id: @store_id)
  end
end
