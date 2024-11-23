# frozen_string_literal: true

class StoreSerializer < ActiveModel::Serializer
  attributes :name, :image_urls

  has_many :stores_working_hours, key: :working_hours
end
