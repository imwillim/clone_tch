# frozen_string_literal: true

class StoreWorkingHourSerializer < ActiveModel::Serializer
  attributes :day, :open_hour, :close_hour

  def open_hour
    object.working_hour.open_hour
  end

  def close_hour
    object.working_hour.close_hour
  end
end
