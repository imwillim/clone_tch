# frozen_string_literal: true

class WorkingHourSerializer < ActiveModel::Serializer
  attributes :id, :day, :open_hour, :close_hour

  def open_hour
    object.open_hour.strftime('%H:%M')
  end

  def close_hour
    object.close_hour.strftime('%H:%M')
  end
end
