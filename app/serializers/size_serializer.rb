# frozen_string_literal: true

class SizeSerializer < ActiveModel::Serializer
  attributes :store_id, :name, :icon, :price

  store_id :id
end
