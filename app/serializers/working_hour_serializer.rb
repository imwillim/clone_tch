# frozen_string_literal: true

class WorkingHourSerializer < ActiveModel::Serializer
  attributes :id, :day, :open_hour, :close_hour

  def open_hour
    "#{object.open_hour.hour}:#{'%02i' % object.open_hour.min}"
  end

  def close_hour
    "#{object.close_hour.hour}:#{object.close_hour.min}"
  end
end
