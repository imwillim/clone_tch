# frozen_string_literal: true

class WorkingHourSerializer < ActiveModel::Serializer
  attributes :open_hour, :close_hour
end
