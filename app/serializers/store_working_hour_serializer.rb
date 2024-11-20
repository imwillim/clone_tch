# frozen_string_literal: true

class StoreWorkingHourSerializer < ActiveModel::Serializer
  attributes :day

  belongs_to :store, serializer: StoreSerializer
  belongs_to :working_hour, serializer: WorkingHourSerializer
end
