# frozen_string_literal: true

class StoreSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :stores_working_hours
end
